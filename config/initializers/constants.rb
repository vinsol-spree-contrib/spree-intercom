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
    placed: 'Placed'
  },

  Promotion: {
    create: 'Applied',
    destroy: 'Removed'
  }
}
