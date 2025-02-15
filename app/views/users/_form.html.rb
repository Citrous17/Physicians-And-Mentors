<%= form_with(model: user) do |form| %>
  <% if user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
        <% user.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :last_name %>
    <%= form.text_field :first_name %>
  </div>

  <div class="field">
    <%= form.label :first_name %>
    <%= form.text_field :first_name %>
  </div>

  <div class="field">
    <%= form.label :email %>
    <%= form.number_field :email %>

  </div>

  <div class="field">
    <%= form.label :password %>
    <%= form.number_field :password %>
  </div>

  <div class="field">
    <%= form.label :dob %>
    <%= form.date_select :dob %>
  </div>

  <div class="field">
    <%= form.label :phone_number %>
    <%= form.number_field :phone_number %>
  </div>

  <div class="field">
    <%= form.label :profile_image_url %>
    <%= form.number_field :profile_image_url %>
  </div>

  <div class="field">
    <%= form.label :is_professional %>
    <%= form.number_field :is_professional %>
  </div>


  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
