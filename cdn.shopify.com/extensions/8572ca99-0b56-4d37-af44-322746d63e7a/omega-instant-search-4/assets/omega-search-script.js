function dynamicallyLoadScript(url) {
    var script = document.createElement("script");
    script.src = url;
    document.head.appendChild(script);
}
dynamicallyLoadScript("https://search.omegacommerce.com/instant/initjs?shop="+Shopify.shop)