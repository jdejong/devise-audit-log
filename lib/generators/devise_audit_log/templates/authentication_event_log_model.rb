class AuthenticationEventLog < <%= model_base_class %>
  belongs_to :user, polymorphic: true<%= ar_optional_flag %>

end