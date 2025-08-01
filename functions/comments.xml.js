export async function onRequestGet(context) {
    // Fetch all keys from the BLOG_COMMENTS KV namespace
    const list = await context.env.BLOG_COMMENTS.list();
    const keys = list.keys.map(k => k.name);

    // Fetch all comments in parallel
    const posts = await Promise.all(
        keys.map(async key => {
            const value = await context.env.BLOG_COMMENTS.get(key, { type: "json" });
            return { key, comments: {...value} };
        })
    );

    // console.log("Fetched posts:", posts);

    // Flatten the comments into a single array and add the key to each comment
    let comments = [];
    for (const post of posts) {
        console.log("Processing post:", post);
        const post_comments = post.comments || [];
        for (const comment in post_comments) {
            comments.push({path: post.key, ...post_comments[comment]});
            console.log("Added comment:", comment);
        }
    }
    console.log("Flattened comments:", comments);

    // Sort comments by date (assuming 'date' field in ISO format)
    comments.sort((a, b) => new Date(b.date) - new Date(a.date));

    // Generate RSS XML
    const rssItems = comments.map(comment => `
                <item>
                    <title><![CDATA[${comment.name || "Anonymous"}]]></title>
                    <link>https://stevetech.me${comment.path}</link>
                    <description><![CDATA[${comment.text || ""}]]></description>
                    <pubDate>${new Date(comment.date).toUTCString()}</pubDate>
                </item>
    `).join("");

    const rss = `<?xml version="1.0" encoding="UTF-8" ?>
        <rss version="2.0">
            <channel>
                <title>Steve's Blog Comments</title>
                <link>https://stevetech.me/</link>
                <description>Recent comments from the blog</description>
                ${rssItems}
            </channel>
        </rss>
    `;

    return new Response(rss, {
        headers: { "Content-Type": "application/xml; charset=UTF-8" }
    });
}