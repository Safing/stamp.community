module StampPresenter
  class Entity < Grape::Entity
    expose :id, documentation: {
      type: 'Integer',
      desc: 'Stamp id',
      required: true
    }

    expose :percentage, documentation: {
      type: 'Integer',
      desc: 'Percentage (1..100)',
      required: true
    }

    expose :state, documentation: {
      type: 'String',
      desc: 'State',
      required: true
    }

    expose :domain_id do |stamp, _|
      stamp.stampable_id
    end

    expose :domain do |stamp, _|
      stamp.stampable.name
    end
  end

  class Collection < Grape::Entity
    present_collection true
    expose :items, as: :stamps, using: StampPresenter::Entity
  end
end
