INTERCOM_SERVICE_MAPPER = {
  product: {
    show: Spree::Intercom::Events::Product::ViewService,
    index: Spree::Intercom::Events::Product::SearchService
  },

  line_item: {
    create: Spree::Intercom::Events::LineItem::CreateService,
    update: Spree::Intercom::Events::LineItem::UpdateService,
    destroy: Spree::Intercom::Events::LineItem::DeleteService
  },

  user_session: {
    create: Spree::Intercom::Events::UserSession::LoginService,
    destroy: Spree::Intercom::Events::UserSession::LogoutService
  },

  taxon: {
    show: Spree::Intercom::Events::Taxon::FilterService
  },

  order: {
    update: Spree::Intercom::Events::Order::StateChangeService,
    placed: Spree::Intercom::Events::Order::PlaceService
  },

  order_promotion: {
    create: Spree::Intercom::Events::OrderPromotion::ApplyService,
    destroy: Spree::Intercom::Events::OrderPromotion::RemoveService
  },

  shipment: {
    update: Spree::Intercom::Events::Shipment::ShipService
  },

  customer_return: {
    create: Spree::Intercom::Events::Customer::ReturnService
  }
}
