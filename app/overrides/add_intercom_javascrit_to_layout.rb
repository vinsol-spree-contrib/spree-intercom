Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'add_intercom_javascript_to_layout',
  insert_bottom: 'body',
  partial: 'spree/intercom/widget'
)
