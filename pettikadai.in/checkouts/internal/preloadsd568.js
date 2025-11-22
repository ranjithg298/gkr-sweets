
    (function() {
      var cdnOrigin = "https://cdn.shopify.com";
      var scripts = ["/cdn/shopifycloud/checkout-web/assets/c1/polyfills-legacy.CxAH3j_U.js","/cdn/shopifycloud/checkout-web/assets/c1/app-legacy.BhfNu5dd.js","/cdn/shopifycloud/checkout-web/assets/c1/locale-en-legacy.C-HF1EZ8.js","/cdn/shopifycloud/checkout-web/assets/c1/page-OnePage-legacy.BqVGrw4R.js","/cdn/shopifycloud/checkout-web/assets/c1/LocalizationExtensionField-legacy.Cn3xMPNP.js","/cdn/shopifycloud/checkout-web/assets/c1/RememberMeDescriptionText-legacy.FPRSMASx.js","/cdn/shopifycloud/checkout-web/assets/c1/ShopPayOptInDisclaimer-legacy.DnPuMkxe.js","/cdn/shopifycloud/checkout-web/assets/c1/PaymentButtons-legacy.DThwU7Iz.js","/cdn/shopifycloud/checkout-web/assets/c1/StockProblemsLineItemList-legacy.C5mJKNPW.js","/cdn/shopifycloud/checkout-web/assets/c1/DeliveryMethodSelectorSection-legacy.In7LK_xS.js","/cdn/shopifycloud/checkout-web/assets/c1/useEditorShopPayNavigation-legacy.C7t-1P-E.js","/cdn/shopifycloud/checkout-web/assets/c1/VaultedPayment-legacy.D6RBiN4L.js","/cdn/shopifycloud/checkout-web/assets/c1/SeparatePaymentsNotice-legacy.EWDDw1h2.js","/cdn/shopifycloud/checkout-web/assets/c1/ShipmentBreakdown-legacy.BRs6AEld.js","/cdn/shopifycloud/checkout-web/assets/c1/MerchandiseModal-legacy.iP1FbQJo.js","/cdn/shopifycloud/checkout-web/assets/c1/StackedMerchandisePreview-legacy.Ckmg_1Uo.js","/cdn/shopifycloud/checkout-web/assets/c1/component-ShopPayVerificationSwitch-legacy.Bqi65zcD.js","/cdn/shopifycloud/checkout-web/assets/c1/useSubscribeMessenger-legacy.DK3Z-cW1.js","/cdn/shopifycloud/checkout-web/assets/c1/index-legacy.BYNXwveP.js","/cdn/shopifycloud/checkout-web/assets/c1/PayButtonSection-legacy.B2UuHTZv.js"];
      var styles = [];
      var fontPreconnectUrls = ["https://fonts.shopifycdn.com"];
      var fontPrefetchUrls = ["https://fonts.shopifycdn.com/lato/lato_n4.c3b93d431f0091c8be23185e15c9d1fee1e971c5.woff2?h1=cGV0dGlrYWRhaS5pbg&hmac=af703a6d44e67e829ced038805f22f74b3242f40b3b36d6fad8b790d58d5dbb3","https://fonts.shopifycdn.com/lato/lato_n7.900f219bc7337bc57a7a2151983f0a4a4d9d5dcf.woff2?h1=cGV0dGlrYWRhaS5pbg&hmac=d05de955e2e0647ee5232eb59a7d18a2c697a958b71bcb62a6eaa293d071b221","https://fonts.shopifycdn.com/pt_serif/ptserif_n4.5dc26655329dc6264a046fc444eea109ea514d3d.woff2?h1=cGV0dGlrYWRhaS5pbg&hmac=ead76dc8e2960e26ceff1f13f4f8d2021d808df2103efa79cbd8735d2c11a864","https://fonts.shopifycdn.com/pt_serif/ptserif_n7.05b01f581be1e3c8aaf548f8c90656344869b497.woff2?h1=cGV0dGlrYWRhaS5pbg&hmac=27f93d81182fc182cf6d1757a1df650e116ef8ed7bc2b085ccc0b7350196ae8c"];
      var imgPrefetchUrls = ["https://cdn.shopify.com/s/files/1/0537/5249/6309/files/LOGO-TM-SMALL_copy_a11e23d1-93b5-45bf-af7d-25e4e3404d1d_x320.png?v=1735639572"];

      function preconnect(url, callback) {
        var link = document.createElement('link');
        link.rel = 'dns-prefetch preconnect';
        link.href = url;
        link.crossOrigin = '';
        link.onload = link.onerror = callback;
        document.head.appendChild(link);
      }

      function preconnectAssets() {
        var resources = [cdnOrigin].concat(fontPreconnectUrls);
        var index = 0;
        (function next() {
          var res = resources[index++];
          if (res) preconnect(res, next);
        })();
      }

      function prefetch(url, as, callback) {
        var link = document.createElement('link');
        if (link.relList.supports('prefetch')) {
          link.rel = 'prefetch';
          link.fetchPriority = 'low';
          link.as = as;
          if (as === 'font') link.type = 'font/woff2';
          link.href = url;
          link.crossOrigin = '';
          link.onload = link.onerror = callback;
          document.head.appendChild(link);
        } else {
          var xhr = new XMLHttpRequest();
          xhr.open('GET', url, true);
          xhr.onloadend = callback;
          xhr.send();
        }
      }

      function prefetchAssets() {
        var resources = [].concat(
          scripts.map(function(url) { return [url, 'script']; }),
          styles.map(function(url) { return [url, 'style']; }),
          fontPrefetchUrls.map(function(url) { return [url, 'font']; }),
          imgPrefetchUrls.map(function(url) { return [url, 'image']; })
        );
        var index = 0;
        function run() {
          var res = resources[index++];
          if (res) prefetch(res[0], res[1], next);
        }
        var next = (self.requestIdleCallback || setTimeout).bind(self, run);
        next();
      }

      function onLoaded() {
        try {
          if (parseFloat(navigator.connection.effectiveType) > 2 && !navigator.connection.saveData) {
            preconnectAssets();
            prefetchAssets();
          }
        } catch (e) {}
      }

      if (document.readyState === 'complete') {
        onLoaded();
      } else {
        addEventListener('load', onLoaded);
      }
    })();
  