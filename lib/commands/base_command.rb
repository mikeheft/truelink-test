# frozen_string_literal: true

class BaseCommand
  def self.call(**args)
    new.call(**args)
  end
  private_class_method :new

  def call(**args)
    raise NotImplementedError, 'Must define #call method'
  end
end
