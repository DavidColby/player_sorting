# frozen_string_literal: true

class TableReflex < ApplicationReflex
  def sort
    players = Player.includes(:team).order("#{element.dataset.column} #{element.dataset.direction}")
    morph '#players', render(partial: 'players', locals: { players: players })
    set_sort_direction
    insert_indicator
  end

  private

  def next_direction(direction)
    direction == 'asc' ? 'desc' : 'asc'
  end

  def set_sort_direction
    direction = next_direction(element.dataset.direction)

    cable_ready
      .set_dataset_property(
        selector: "##{element.id}",
        name: 'direction',
        value: direction
      )
  end

  def insert_indicator
    cable_ready
      .prepend(
        selector: "##{element.id}",
        html: render(
          partial: 'players/sort_indicator',
          locals: { direction: element.dataset.direction }
        )
      )
  end
end
