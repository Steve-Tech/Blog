if (document.querySelector("#comments>div.alert") == null) {
    function addComment(reply = null) {
        let comment_form = document.getElementById("new-comment-form");
        if (reply) {
            comment_form.classList.add("ms-5", "mb-2");
            comment_form.classList.remove("mt-2");
            let form_elem = comment_form.querySelector("form");
            let reply_field = form_elem.querySelector("input[name='reply']") || document.createElement("input");
            reply_field.type = "hidden";
            reply_field.name = "reply";
            reply_field.value = reply.closest(".card").dataset.commentId;
            form_elem.appendChild(reply_field);
            comment_form.querySelector("button[type='submit']").innerText = "Reply to Existing Comment";
            reply.closest("#comments>.card[data-comment-id]").after(comment_form);
        } else {
            comment_form.classList.remove("ms-5", "mb-2");
            comment_form.classList.add("mt-2");
            comment_form.querySelector("form>input[name='reply']")?.remove();
            comment_form.querySelector("button[type='submit']").innerText = "Create New Comment";
            btn_new_comment.after(comment_form);
        }
        comment_form.querySelector(".cf-turnstile>div")?.remove();
        turnstile.render(comment_form.querySelector(".cf-turnstile"), {
            sitekey: comment_form.querySelector(".cf-turnstile").dataset.sitekey,
        });
        comment_form.classList.remove("d-none");
    }

    let btn_new_comment = document.getElementById("new-comment-btn");
    btn_new_comment.addEventListener("click", () => addComment());
    btn_new_comment.classList.remove("d-none");

    for (let btn_reply of document.querySelectorAll(".card-link")) {
        btn_reply.addEventListener("click", () => addComment(btn_reply));
    }

    for (let comment of document.querySelectorAll("span.comment-date[data-date]")) {
        comment.innerText = new Date(comment.dataset.date).toLocaleString(undefined, {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }
}