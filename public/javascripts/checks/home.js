var domains = ['hotmail.com', 'gmail.com', 'aol.com'];                     
$('#user_email').on('blur', function() {
  $(this).mailcheck({                                                      
    domains: domains,   // optional
    suggested: function(element, suggestion) {                             
      // callback code                                                     
      // suggestion object
      //address: 'test',          // the address; part before the @ sign   
      //domain: 'hotmail.com',    // the suggested domain                  
      //full: 'test@hotmail.com'  // the full suggested email              
      $('#username_msg').html(
        'do you mean <a href="#" style="font-style:italic;" onclick="email_replace(\''  
    + suggestion.full+'\')">'
    + suggestion.address
    + '@' +
    '<font style="font-weight:bold;">'                                     
    + suggestion.domain 
    +'</font></a>?');
      $('#username_msg').slideDown(1000);
      //$('#username_msg').slideDown('slow');
    },
    empty: function(element) {
      // callback code
    }
  });
});

  function email_replace(email) {
    $('#user_email').val(email);
    $('#username_msg').hide();
  }

  $("#target").keypress(function(event) {
      update($("#pwd_msg"));
  });

  $("#other").click(function() {
    $("#target").keypress(
    function () {
      update($("#pwd_msg"));
    }
    );
  });

  function update(j) {
    var str = j.text();
    var psd_str = $('#target').val();
    var l = psd_str.length;
    if (l < 6) {
      var msg = 'password is too short!';
      j.attr('color','red');
      j.text(msg);
    } else {
      var msg = 'password is good!';
      j.attr('color','green');
      j.text(msg);
    }
  }

