MAPPER = {
  Product: {
    show: 'Spree::Intercom::Events::Product::ViewService',
    index: 'Spree::Intercom::Events::Product::SearchService'
  },

  LineItem: {
    create: 'Spree::Intercom::Events::LineItem::AddService',
    update: 'Spree::Intercom::Events::LineItem::UpdateService',
    destroy: 'Spree::Intercom::Events::LineItem::RemoveService'
  },

  UserSession: {
    create: 'Spree::Intercom::Events::UserSession::LoginService',
    destroy: 'Spree::Intercom::Events::UserSession::LogoutService'
  },

  Taxon: {
    show: 'Spree::Intercom::Events::Taxon::FilterService'
  },

  Order: {
    update: 'StateChange',
    placed: 'Place'
  },

  OrderPromotion: {
    create: 'Spree::Intercom::Events::OrderPromotion::ApplyService',
    destroy: 'Spree::Intercom::Events::OrderPromotion::RemoveService'
  },

  Shipment: {
    update: 'Spree::Intercom::Events::Shipment::ShipService'
  },

  CustomerReturn: {
    create: 'Spree::Intercom::Events::CustomerReturn::ReturnService'
  }
}
