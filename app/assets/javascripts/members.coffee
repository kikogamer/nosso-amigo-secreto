$(document).on 'turbolinks:load', ->
  $('#member_email, #member_name').keypress (e) ->
    if e.which == 13 && valid_email($( "#member_email" ).val()) && $( "#member_name" ).val() != ""
      $('.new_member').submit()

  $('#member_email, #member_name').bind 'blur', ->
    if valid_email($( "#member_email" ).val()) && $( "#member_name" ).val() != ""
      $('.new_member').submit()

  $('#name, #email').bind 'blur', ->
    updateMember(this)

  $('body').on 'click', 'a.remove_member', (e) ->
    $.ajax '/members/'+ e.currentTarget.id,
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          Materialize.toast('Membro removido', 4000, 'green')
          $('#member_' + e.currentTarget.id).remove()
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na remoção de membro', 4000, 'red')
    return false

  $('.new_member').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: $(".new_member").serialize()
        success: (data, text, jqXHR) ->
          insert_member(data['id'], data['name'], data['email'], data['campaign_id'])
          $('#member_name, #member_email').val("")
          $('#name, #email').bind 'blur', ->
            updateMember(this)
          $('#member_name').focus()
          Materialize.toast('Membro adicionado', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na hora de incluir membro', 4000, 'red')
    return false

valid_email = (email) ->
  /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(email)

insert_member = (id, name, email, campaign_id) ->
  $('.member_list').append(
    '<form id="edit_member_' + id + '" class="edit_member" action="/members/' + id + '" accept-charset="UTF-8" method="post"> '+
      '<div class="member" id="member_' + id + '">' +
        '<div class="row">' +
          '<input id="member_campaign_id" value="' + campaign_id + '" name="member[campaign_id]" type="hidden">'+
          '<div class="col s12 m5 input-field">' +
            '<input id="name" type="text" name="member[name]" class="validate" value="' + name + '">' +
            '<label for="name" class="active">Nome</label>' +
          '</div>' +
          '<div class="col s12 m5 input-field">' +
            '<input id="email" type="email" name="member[email]" class="validate" value="' + email + '">' +
            '<label for="email" class="active" data-error="Formato incorreto">Email</label>' +
          '</div>' +
          '<div class="col s3 offset-s3 m1 input-field">' +
            '<i class="material-icons icon">visibility</i>' +
          '</div>' +
          '<div class="col s3 m1 input-field">' +
            '<a href="#" class="remove_member" id="' + id + '">' +
              '<i class="material-icons icon">delete</i>' +
            '</a>' +
          '</div>' +
        '</div>' +
      '</div>' +
    '</form>'
    )

updateMember = (element) ->
  form = $(element.form);
  $.ajax form.attr('action'),
    type: 'PUT',
    dataType: 'json',
    data: form.serialize(),
    success: (data, text, jqXHR) ->
      Materialize.toast('Membro atualizado', 4000, 'green')
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(jqXHR.responseText)
      Materialize.toast('Problema na hora de atualizar o membro', 4000, 'red')
