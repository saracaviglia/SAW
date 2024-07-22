<nav class="global-navbar">

  <div>
    <a href="search">SHOP</a>
    <a href="about">ABOUT</a>
    <a href="#">MORE</a>
  </div>

  <a href=""><img src="client/public/img/new_logo.png" width="75px"></a>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    const s = new searchProduct();
    $(document).ready(function() {
      $('.search').each(function() {
        var self = $(this);
        var div = self.children('form');
        var input = div.children('input');
        var placeholder = input.attr('placeholder');
        var placeholderArr = placeholder.split(/ +/);

        if (placeholderArr.length && div.children('form').length === 0) {
          var spans = $('<div />');
          $.each(placeholderArr, function(index, value) {
            spans.append($('<span />').html(value + '&nbsp;'));
          });
          div.append(spans);
        }

        self.click(function() {
          self.addClass('open');
          setTimeout(function() {
            input.focus();
          }, 750);
        });

        $(document).click(function(e) {
          if (!$(e.target).is(self) && !jQuery.contains(self[0], e.target)) {
            self.removeClass('open');
          }
        });
      });
    });
  </script>

  <div class="left-nav">
    <div class="search">
      <svg x="0px" y="0px" viewBox="0 0 24 24" width="20px" height="20px">
        <g stroke-linecap="square" stroke-linejoin="miter" stroke="currentColor">
          <line fill="none" stroke-miterlimit="10" x1="22" y1="22" x2="16.4" y2="16.4" />
          <circle fill="none" stroke="currentColor" stroke-miterlimit="10" cx="10" cy="10" r="9" />
        </g>
      </svg>
      <form onsubmit="event.preventDefault(); s.search()">
        <input id="search-input" type="text" placeholder="Search..." onkeyup="s.changeSearch()" onsubmit="s.search()">
      </form>
    </div>

    <div id="profile" class="profile-btn">
      <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
        <path d="M480-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47ZM160-160v-112q0-34 17.5-62.5T224-378q62-31 126-46.5T480-440q66 0 130 15.5T736-378q29 15 46.5 43.5T800-272v112H160Zm80-80h480v-32q0-11-5.5-20T700-306q-54-27-109-40.5T480-360q-56 0-111 13.5T260-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T560-640q0-33-23.5-56.5T480-720q-33 0-56.5 23.5T400-640q0 33 23.5 56.5T480-560Zm0-80Zm0 400Z" />
      </svg>
      <div id="popup-profile" class="popup-menu">
        <!-- Menu items go here -->
        <div id="user-links"></div>
        <a href="cart">
          <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
            <path d="M280-80q-33 0-56.5-23.5T200-160q0-33 23.5-56.5T280-240q33 0 56.5 23.5T360-160q0 33-23.5 56.5T280-80Zm400 0q-33 0-56.5-23.5T600-160q0-33 23.5-56.5T680-240q33 0 56.5 23.5T760-160q0 33-23.5 56.5T680-80ZM246-720l96 200h280l110-200H246Zm-38-80h590q23 0 35 20.5t1 41.5L692-482q-11 20-29.5 31T622-440H324l-44 80h480v80H280q-45 0-68-39.5t-2-78.5l54-98-144-304H40v-80h130l38 80Zm134 280h280-280Z" />
          </svg>
        </a>
      </div>

      <script>
        document.addEventListener("DOMContentLoaded", function() {
          (async () => {
            const user_status = await get_user_status();
            
            if (user_status['isLogged']) {
              document.getElementById('user-links').innerHTML = `
                <a href="profile">Profile</a>
                <button onclick="logout()">Logout</button>
              `;
            } else {
              document.getElementById('user-links').innerHTML = `
                <a href="login">Login</a>
                <a href="registration">Register</a>
              `;
            }
          })();
        });
      </script>

    </div>
  </div>
</nav>