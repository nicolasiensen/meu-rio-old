$(document).ready(function(){

  var $new_comment = $('#new_comment');
  var $form = $("form#new_comment");
  var $submitButton = $form.find('input[name="commit"]');
  var $comment_count = $('.comments_tooltip');

  var page = 2;
  var debate = $("h1.grid_12").attr("data-debate");

  var openNewComment = function(){
    $('.new_comment_loading').show();
    $.get('/debates/' + debate + '/comments').success(function(data){
      $('.previous_comments .comment').remove();
      $('.previous_comments').prepend(data);
      rebindFlagLinks();
      page = Math.ceil($('.previous_comments .comment').length / 5) + 1;
      $new_comment.show(); 
      $(window).scrollTop($('.previous_comments .comment:last').offset().top);
      $("#bottom_buttons").hide();
    })
    .complete(function(){
      $('.new_comment_loading').hide();
    });
  }

  //show and hide comment box
  var closeNewComment = function(){
    window.location.hash = 'comments_bottom';
    $('#comment_content').val('');
    $new_comment.hide(); 
    $("#bottom_buttons").show();
  }


  $(window).bind('hashchange', function(){
    if(window.location.hash == '#new_comment'){
      openNewComment();
    }
  });

  $('#new_comment').hide();

  //$('.join_the_conversation').bind('click', openNewComment);

  $('#close').bind('click', closeNewComment);

  //comment submissision and validation
  $form.validate({
    messages: {
      "comment[content]": "Por favor preencha o seu comentário."
    }
  });

  $submitButton.bind('click', function(){
    if($form.valid()){
      $submitButton.data( 'origText', $(this).val());
      $submitButton.val( "Enviando...");
    }
  });

  $form.bind("ajax:success", function(evt, data, status, xhr){
      $form.find('textarea').val("");
      $('.previous_comments .comment:last').after(data);
      $comment_count.each(function(){
        $(this).text(parseInt($(this).text()) + 1);
      });
    }).bind("ajax:complete", function(evt, xhr, status){
      $submitButton.val($submitButton.data('origText'));
      closeNewComment();
    }).bind("ajax:error", function(evt, xhr, status, error){
      $form.prepend("There were errors with the the submission. Please reload the page and try again.");
    });

    //load more comments via ajax

    $load_more = $("#load_more");
    
    $load_more.bind('click', function(e, callback){
      $load_more.data('origText', $(this).html());
      $load_more.html( "Carregando..." );
      $.ajax({
          url: '/debates/' + debate + '/load_comments/' + page,
          type: 'GET',
          dataType: 'html',
          success: function(data){
            if (data){
              page++;
              $('.previous_comments .comment:last').after(data);
              $load_more.html($load_more.data('origText'));
              rebindFlagLinks();
            } else {
              $load_more.html("Todos os comentários estão visíveis agora");  
            };
            if(callback){ callback(data); }
          },
          error: function(xhr, status){
            $load_more.html("There's been an error. Please reload the page.");
          }
      });
    });

    function rebindFlagLinks(){
      $('.flag').unbind();
      $('.flag').bind('ajax:success', function(event, data){
        var link = $(this);
        if(link.data("method") == "post"){
          link.html(unflag_label).data("method", "delete").attr("href", link.attr("href") + "/" + data.id);
        }
        else{
          var path_array = link.attr("href").split("/");
          var path = path_array.slice(0, (path_array.length - 1)).join("/");
          link.html(flag_label).data("method", "post").attr("href", path);
        }
      }).bind("ajax:complete", function(evt, xhr, status){
        $(this).show();
        $(this).next(".flag_loading").hide();
      }).bind("ajax:error", function(evt, xhr, status, error){
        $(this).html("There was an error while flagging the comment. Please reload the page.");
      });

      $(".flag").bind("click", function(){
        $(this).hide();
        $(this).next(".flag_loading").show();
      });
    }
    rebindFlagLinks();
});
