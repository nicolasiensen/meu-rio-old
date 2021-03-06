MR = {
  editable: {
    defaults: {
      tooltip: "Clique para editar...",
      submit: "Ok",
      cancel: "Cancelar",
      onblur: "ignore"
    }
  },

  common: {
    finish: function(){
      Backbone.history.start();
    },

    init: function() {

      // Fixing the behavior of z-index, not the best tho.
      $('iframe').each(function(){
        var url = $(this).attr('src');
        $(this).attr('src', url + "?wmode=transparent");
      });
      // application-wide code
      if(!window.store){
        window.store = new Store('global');
      }

      if(!MR.router){
        MR.router = new MR.Router();
      }

      MR.common.closeFlash();

      MR.common.faceboxInit();
      MR.common.setBodyBackgroundClass();
      MR.common.setupLogoAnimation();
      MR.common.loadMemberRegistration();

      $('.member_panel .right.info').bind('click', function(){
        MR.common.openMemberFlyout();
      });

      $("#new_registration #member_new").live('submit', function(e){
        e.preventDefault();
        var $form = $(this), $errors = $(".signup_errors");
        $errors.hide();
        if($form.valid()){
          var data = $form.serialize();
          $form.find("input[type='submit']").hide();
          $form.find("img[class='loader']").show();
          $.post("/members", data, function(data, textStatus, jqXHR){
            $form.find("input[type='submit']").show();
            $form.find("img[class='loader']").hide();
            if(data.errors != null){
              var error_data = '';
              for(error in data.errors){
                error_data = error_data + data.errors[error] + "</br>";
              }
              $errors.show();
              $errors.html(error_data);
            }else{
              if(data.flash != null){
                $("#flashTemplate").tmpl(data).prependTo("body");
              }
              $(document).trigger('close.facebox');
            }
          });
        }
      });

      $("#sign_in_form #member_new").live('submit', function(e){
        e.preventDefault();
        var $form = $(this), $errors = $(".signin_errors");
        $errors.hide();
        data = $form.serialize();
        $form.find("input[type='submit']").hide();
        $form.find("img[class='loader']").show();
        $.post("/members/sign_in", data, function(data, textStatus, jqXHR){
          $form.find("input[type='submit']").show();
          $form.find("img[class='loader']").hide();
          if(data.logged_in === true){
            if (data.doorkeeper_redirect != null)
              location = data.doorkeeper_redirect;
            else
              location.reload();
          }else{
            $errors.html("Email ou senha inv??lidos.");
            $errors.show();
          }
        });
      });

      $('.back a').live('click', function(e){
        e.preventDefault();
        var target = $(this).attr('href');
        $(".popup .content").html($(target).html());
      });

      $('#resend_password').live('click', function(e){
        e.preventDefault();
        $.get("/members/passwords/resend");
      });

      $(window).bind('hashchange', MR.common.openLogin);
      MR.common.openLogin();
    },

    openLogin: function(){
      if(window.location.hash == '#login'){
        $.facebox({ div: '#login' });
      }
    },

    loadMemberRegistration : function() {
      $('#create a').live('click', function(e){
        e.preventDefault();
        var $content = $(".popup .content");
        $content.load("/members/sign_up", function(){
          $("form#member_new").validate({
            messages: {
              "member[first_name]": "Campo obrigat??rio",
              "member[last_name]": "Campo obrigat??rio",
              "member[email]": {"required": "Campo obrigat??rio", "email": "E-mail inv??lido"},
              "member[password]": "Campo obrigat??rio",
              "member[password_confirmation]": "Campo obrigat??rio"
            }
          });
        });
      });
    },

    updateIdeaLikes: function(updateUrl, likes){
      var idea = {
        "idea": {
          "likes": likes,
        }
      };
      $.ajax({
        type: "PUT",
        data: idea,
        url: updateUrl,
        success: function(data){
        },
        error: function(data){
        }
      });
    },

    searchCategoryId : function(id){
      return MR.router.navigate('category/' + id, true);
    },

    setupLogoAnimation : function() {
      $('a span.logo').hover(
        function(e){$('a span.tagline').fadeIn();},
        function(e){$('a span.tagline').fadeOut();}
      );
    },

    closeFlash : function(){
      $('#close_messages').live('click', function(e){
        e.preventDefault();
        $('.messages').slideUp();
      });
    },

    openMemberFlyout : function(){
      var $panel = $('.member_panel'), $flyout = $('.flyout');
      var open = !0;
      $flyout.show();
      $panel.addClass("active");
      $(document).bind("click.member_panel", function(){
        open ? open = !1 : ($(document).unbind("click.member_panel"), $panel.removeClass("active"), $flyout.hide());
      });
    },

    addFragmentListener: function(){
        store.set('lastFragment', $(this).data('record-fragment'));
      },

    faceboxInit: function(){
      $.facebox.settings.closeImage = "/assets/closelabel.png";
      $.facebox.settings.loadingImage = "/assets/loading.gif";
      $("[rel=facebox]").facebox();
      $(document).bind('close.facebox', function() { window.location.hash = ""; });
      $(document).bind('reveal.facebox', function() {
        $('#mr_login a').click(function(e){
          e.preventDefault();
          var $content = $(".popup .content");
          $content.load("/members/sign_in");
        });
      });
    },

    handleFragmentEvent: function(){
      if(store.get('lastFragment')){
        window.location.href = window.location.href + '#' + store.get('lastFragment');
        store.remove('lastFragment');
      }
    },

    /**
     * Adds a random class to the body which CSS uses to set the background img
     */
    setBodyBackgroundClass: function(){
        var backgrounds = ['blue', 'green', 'orange', 'pink'],
            thisBackground = backgrounds[Math.round(Math.random()*100%3)];

        $('body').addClass('background_' + thisBackground);
      },

    mainNavDonationLink: function(){
      $('#main_nav_donate').click(function(){
        $('.moip form').submit();
        return false;
      });
    },
    setUpDropDowns: function(callback){

      $(".dropdown dt").bind('click', function() {
          $(this).siblings('dd').children('ul').toggle();
      });

      $(".dropdown dd ul li a").unbind('click').bind('click', function(e) {
        e.preventDefault();
        var $this = $(this);
        var text = $this.html();
        var $dropdown = $this.parents('.dropdown');
        $dropdown.children('dt').children('span').html(text);
        $dropdown.children('dd').children('ul').hide();
        callback ? callback(this) : function(){};
      });

      $(document).unbind('click').bind('click', function(e) {
        var $clicked = $(e.target);
        if (!$clicked.parents().hasClass("dropdown")){
          $('.dropdown dd ul').hide();
        }
      });

      //initializers
      MR.issues.removeLastBorder();
      if(Modernizr.history){
        window.addEventListener("popstate", function(e){
          if(e.state !== null){
            MR.issues.replaceArticles(e.state);
            $(".dropdown dt span").html(e.state.issue.name);
          }
        });
      }
    }
  },

  users: {
    init: function(){
      // controller-wide code
    },

    show: function() {
      // action-specific code
    }
  }
};
