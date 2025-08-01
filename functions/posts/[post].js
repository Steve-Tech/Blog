class AlertWriter {
    constructor(message) {
        this.message = message;
    }
    element(element) {
        element.setInnerContent(this.message, {html: true});
    }
}

class RemoveWriter {
    element(element) {
        element.remove();
    }
}

class CommentWriter {
    constructor(comments) {
        this.post_comments = comments;
    }
    element(element) {
        if (element.getAttribute('role') === 'alert') {
            element.remove();
        } else {
            for (let i = this.post_comments.length-1; i >= 0; i--) {
                let comment = this.post_comments[i];
                if (comment.parent == null) {
                    for (let j = this.post_comments.length-1; j >= 0; j--) {
                        let comment2 = this.post_comments[j];
                        if (comment2.parent === i) {
                            element.after(generateComment(comment2, j, true), {html: true});
                        }
                    }
                    element.after(generateComment(comment, i), {html: true});
                }
            }
        }
    }
}

function escapeString(str) {
    return str.replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}

function formatMD(str) {
    return str.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
        .replace(/\*(.*?)\*/g, "<em>$1</em>")
        .replace(/__(.*?)__/g, "<strong>$1</strong>")
        .replace(/_(.*?)_/g, "<em>$1</em>")
        .replace(/```(.*?)```/gs, "<pre>$1</pre>")
        .replace(/`(.*?)`/g, "<code>$1</code>")
        .replace(/~~(.*?)~~/g, "<del>$1</del>")
        .replace(/\n\n/g, "<br>");
}

function formatDate(dateStr) {
    if (!dateStr) return "";
    const date = new Date(dateStr);
    return date.toLocaleString(undefined, {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

function generateComment(comment, id, child=false) {
    let comment_card = `<div class="card bg-light mb-2 ${child ? 'ms-5': ''}" data-comment-id="${id}">
        <div class="card-body">
            <h5 class="card-title">
                <span ${comment?.isMe ? 'class="fst-italic text-decoration-underline"' : ''}>${comment?.name}</span>
                <span class="comment-date ms-2 fw-bold" data-date="${comment?.date}">${formatDate(comment?.date)}</span>
            </h5>
            <p class="card-text">${formatMD(comment.text)}</p>
            <a href="javascript:;" class="card-link">Reply</a>
        </div>
    </div>`

    return comment_card;
}

export async function onRequestGet(context) {
    const { request, env } = context;
    const assetResponse = await env.ASSETS.fetch(request);
    const url = new URL(request.url);
    const key = url.pathname;

    let comments = (await context.env.BLOG_COMMENTS.get(key, {type: 'json'})) ?? [];

    let lastModified = null;
    
    if (comments.length > 0) {
        lastModified = comments.reduce((latest, comment) => {
            const commentDate = new Date(comment.date);
            return commentDate > latest ? commentDate : latest;
        }, new Date(0));
    }

    // Transform the HTML
    const newResponse = await new HTMLRewriter()
        .on('div#comments>div', new CommentWriter(comments))
        .transform(assetResponse);

    // Clone headers and set Last-Modified
    const headers = new Headers(newResponse.headers);
    if (lastModified)
        headers.set('Last-Modified', lastModified.toUTCString());

    // Return a new Response with the modified headers
    return new Response(await newResponse.text(), {
        status: newResponse.status,
        statusText: newResponse.statusText,
        headers,
    });
}

export async function onRequestPost(context) {
    const { request, env } = context;
    if (request.headers.get('content-type')?.includes('form')) {
        const url = new URL(request.url);
        const assetResponse = await env.ASSETS.fetch(url);

        if (!assetResponse.ok) {
            return context.next();
        }

        const formData = await request.formData();
        const key = url.pathname;
        // Turnstile injects a token in "cf-turnstile-response".
        const token = formData.get("cf-turnstile-response");
        const ip = request.headers.get("CF-Connecting-IP");

        // Validate the token by calling the
        // "/siteverify" API endpoint.
        let turnstileData = new FormData();
        turnstileData.append("secret", env.TURNSTILE_SECRET_KEY);
        turnstileData.append("response", token);
        turnstileData.append("remoteip", ip);

        const turnstileUrl = "https://challenges.cloudflare.com/turnstile/v0/siteverify";
        const result = await fetch(turnstileUrl, {
            body: turnstileData,
            method: "POST",
        });

        const outcome = await result.json();
        if (!outcome.success) {
            const newResponse = await new HTMLRewriter()
                .on('div#comments>div[role="alert"]',
                    new AlertWriter(
                        "<strong>Turnstile verification failed.</strong> Please go back and try again.<br>" + 
                        "If you can't pass Turnstile for technical or privacy reasons, please email me and I'll manually add your comment."
                    ))
                .on('#new-comment-btn', new RemoveWriter())
                .on('#new-comment-form', new RemoveWriter())
                .on('script[data-id="comments.js"]', new RemoveWriter())
                .transform(assetResponse);
            
            return new Response(await newResponse.text(), {
                status: 400,
                headers: newResponse.headers,
            });
        }

        const body = {};
        for (const entry of formData.entries()) {
            body[entry[0]] = entry[1];
        }

        let comments = (await env.BLOG_COMMENTS.get(key, {type: 'json'})) ?? [];

        for (const entry of formData.entries()) {
            console.log(`${entry[0]}: ${entry[1]}`);
        }

        if (!body['name'] || !body['text']) {
            return new Response('Name and text are required.', {status: 400});
        }

        let parent = body['reply'] ? parseInt(body['reply']) : null;
        if (parent !== null) {
            if (!comments[parent]) {
                return new Response('Parent comment not found.', {status: 400});
            }
            // Find the top-level parent
            while (comments[parent] && comments[parent].parent !== null) {
                parent = comments[parent].parent;
            }
        }

        let newComment = {
            name: body['name'],
            email: body['email'],
            text: escapeString(body['text']),
            parent: parent,
            date: new Date().toISOString(),
            ip: ip,
            isMe: body['email'] === env.ME_KEY || undefined,
        }

        await env.BLOG_COMMENTS.put(key, JSON.stringify([...comments, newComment]));

	    return new Response(null, {status: 303, headers: {'Location': key}
        });
    }

    // This returns a 404 if another page doesn't exist
    return await context.next();
}