(function() {
  var jwt = null;

  var getJWT = function() {
    return localStorage.getItem('jwt');
  }

  var setJWT = function(token) {
    jwt = token;
    if(!!jwt) {
      localStorage.setItem('jwt', token);
    } else {
      localStorage.removeItem('jwt');
    }
    document.getElementById('jwt').innerHTML = token;
  }

  var log = function(tag, text) {
    var $log = document.getElementById("log");
    var $text = document.createElement(tag);
    $text.innerHTML = text;
    $log.appendChild($text);
  };

  var updateButtons = function() {
    jwt = getJWT();
    var buttons = document.getElementsByClassName("auth");
    Array.prototype.forEach.call(buttons, (button, index) => button.disabled = !!jwt ? null : 'true');
  };

  window.logout = function() {
    setJWT();
    log('div', 'logout');
    updateButtons();
  };

  window.makeRequest = function(request) {
    return fetch(request)
      .then((resp) => {
        switch(resp.status) {
          case 401:
            return "401: Unauthorized"
            break;
          case 400:
          case 200:
          case 201:
            return resp.json()
            break;
        }
      })
      .then((data) => {
        if(!!data.jwt) {
          setJWT(data.jwt);
          updateButtons();
        }
        log("div", JSON.stringify(data))
      })
  };

  window.statusRequest = function() {
    return new Request('http://localhost:3000/status', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${jwt}`
      },
    })
  };


  window.userStatusRequest = function() {
    return new Request('http://localhost:3000/status/user', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${jwt}`
      },
    })
  };

  window.loginRequest = function() {
    return new Request('http://localhost:3000/user_token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        auth: {
          email: "1@user.com",
          password: "password"
        }
      })
    })
  };

  window.onload = function() {
    setJWT(getJWT());
    updateButtons();
  }

})()
