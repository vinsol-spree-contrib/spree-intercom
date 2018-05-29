MAPPER = {
  Product: {
    show: 'View',
    index: 'Search'
  },

  LineItem: {
    create: 'Create',
    update: 'Update',
    destroy: 'Remove'
  },

  Taxon: {
    show: 'Filter'
  },

  Order: {
    update: 'StateChange',
    placed: 'Place'
  },

  OrderPromotion: {
    create: 'Apply',
    destroy: 'Remove'
  },

  Shipment: {
    update: 'Ship'
  },

  CustomerReturn: {
    create: 'Return'
  }
}
