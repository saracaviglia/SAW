<!doctype html>
<html lang="it">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <base href="/sawproject/">
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css">
  <link rel="icon" type="image/x-icon" href="././client/public/img/logo.jpeg">
  
  <?php
  foreach ($css as $key => $link) {
    $link = "client/src/style/" . $link . ".css";
    echo "<link rel='stylesheet' href=$link>";
  }
  ?>
  <title><?php echo $title ?? 'Document' ?></title>
  <?php
  foreach ($js as $key => $link) {
    $link = "client/src/js/" . $link . ".js";
    echo '<script src=' . $link . '></script>';
  }
  ?>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/dompurify/2.3.4/purify.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>

<body>

  <!-- <div id="cookie-banner" class="cookie-banner">
    <p>Questo sito utilizza cookie per migliorare l'esperienza di navigazione. Continuando a navigare, accetti l'uso dei cookie.</p>
    <a href="https://www.iubenda.com/privacy-policy/87330868" class="iubenda-white iubenda-noiframe iubenda-embed iubenda-noiframe " title="Privacy Policy ">Privacy Policy</a>
    <script type="text/javascript">
      (function(w, d) {
        var loader = function() {
          var s = d.createElement("script"),
            tag = d.getElementsByTagName("script")[0];
          s.src = "https://cdn.iubenda.com/iubenda.js";
          tag.parentNode.insertBefore(s, tag);
        };
        if (w.addEventListener) {
          w.addEventListener("load", loader, false);
        } else if (w.attachEvent) {
          w.attachEvent("onload", loader);
        } else {
          w.onload = loader;
        }
      })(window, document);
    </script>
    <a href="https://www.iubenda.com/privacy-policy/87330868/cookie-policy" class="iubenda-white iubenda-noiframe iubenda-embed iubenda-noiframe " title="Cookie Policy ">Cookie Policy</a>
    <script type="text/javascript">
      (function(w, d) {
        var loader = function() {
          var s = d.createElement("script"),
            tag = d.getElementsByTagName("script")[0];
          s.src = "https://cdn.iubenda.com/iubenda.js";
          tag.parentNode.insertBefore(s, tag);
        };
        if (w.addEventListener) {
          w.addEventListener("load", loader, false);
        } else if (w.attachEvent) {
          w.attachEvent("onload", loader);
        } else {
          w.onload = loader;
        }
      })(window, document);
    </script>
    <form <button onclick="acceptCookies()" class="accept-btn">Accetta</button>
      <button onclick="dontacceptCookies()" class="dont-accept-btn">Continua senza accettare</button>
    </form>
  </div>

  <script>
    function sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    }

    document.addEventListener('DOMContentLoaded', (event) => {


      async function delay() {
        await sleep(0);
      }

      async function delayAndExecute() {
        await delay();

        if (sessionStorage.getItem('cookiesAccepted') == "false" || sessionStorage.getItem('cookiesAccepted') === null) {
          document.getElementById('cookie-banner').style.display = 'block';
        } else {
          document.getElementById('cookie-banner').style.display = 'none';
        }
      }

      delayAndExecute();


    });

    function acceptCookies() {
      sessionStorage.setItem('cookiesAccepted', 'true');
      document.getElementById('cookie-banner').style.display = 'none';
    }

    function dontacceptCookies() {
      sessionStorage.setItem('cookiesAccepted', 'false');
      document.getElementById('cookie-banner').style.display = 'none';
    }
  </script> -->