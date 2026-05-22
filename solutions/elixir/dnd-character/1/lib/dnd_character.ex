defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    ((score - 10) / 2)
    |> floor()
  end

  @spec ability :: pos_integer()
  def ability do
    Enum.random(3..18)
  end

  # You find your character’s constitution modifier by subtracting 10
  # from your
  # character’s constitution - 10, divide by 2 and round down.

  # Your character’s initial hitpoints are 10 + your character’s constitution modifier.
  # character.hitpoints === 10 + modifier(character.constitution)

  @spec character :: t()
  def character do
    constitution = ability()

    %__MODULE__{
      strength: ability(),
      dexterity: ability(),
      constitution: constitution,
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability(),
      hitpoints: 10 + modifier(constitution)
    }
  end
end
