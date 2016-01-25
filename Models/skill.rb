# player skill
class Skill
  attr_accessor :id, :name, :description, :effect

  #
  ## CLASS METHODS
  #

  def self.all
    YAML.load_stream(open('db/SkillsDB.yml'))
  end

  def self.list(win)
    win.setpos(2, 2)
    win.addstr("------ skills menu -------")
    win.setpos(3, 2)

    all.each do |skill|
      win.addstr("#{skill.name}")
      win.setpos(win.cury + 1, 2)
      win.addstr("#{skill.description}")
      win.setpos(win.cury + 2, 2)
    end
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(name, description, effect)
    @id = object_id
    @name = name
    @description = description
    @effect = effect
    save
  end

  def save
    File.open('db/SkillsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def take(player)
    send(effect, player)
    player.save
  end

  ##### skill effect methods, will go somewhere else #####

  def incr_crit_chance(player)
    player.crit_chance += 5
  end

  def incr_armor(player)
    player.defense += 200
  end
end
