require 'active_support/concern'

module BuildingBlock
  extend ActiveSupport::Concern
  include ActionView::Helpers::NumberHelper
  include Prawn::View

  def heading(string)
    font('Helvetica', style: :bold){
      text string
    }
  end

  def date_box
    text_box "#{I18n.l(date)}", style.date
  end

  def blue_text(string)
    color_text(string, blue)
  end

  def yellow_text(string)
    color_text(string, yellow)
  end

  def color_text(string, color)
    "<color rgb='#{color}'>#{string}</color>"
  end

  def blue
    "009dc3"
  end

  def grey
    "7c7b7f"
  end

  def yellow
    "f9b625"
  end
end

