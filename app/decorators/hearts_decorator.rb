class HeartsDecorator < Draper::CollectionDecorator
  delegate :exists?
end
