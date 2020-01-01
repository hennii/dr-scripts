# Amalyze and execute moves

require "target"
require "hunt"
require "activate"

Target::auto "*** analyze what? usage: .anal &lt;critter_name&gt; ***"

Client::track_exp "Tactics"

def finally_do
  Client::track_exp_clear
end

Observer::instance.register_timer(15, :active_spells_maintain, 'sagacity prowess')

def advance
  put "advance"
  pause 6
end

def face target
  put "face #{target}"
  match = { :wait => [/\.\.\.wait/],
            :wait_for => [/Face what?|nothing else to face/],
            :next => [/facing a dead/],
            :continue => [/already facing|You turn to face|too closely engaged/],
            :pause => [/You are still stunned/] }

  case match_wait match
    when :wait
      pause 0.5
      face target
    when :pause, :wait_for, :next
      pause 3
      if Target::is_auto and Target::find
        face Target::find
      else
        face target
      end
  end
end

def analyze
  put "analyze"
  match = { :wait => [/\.\.\.wait/],
            :fail => [/fail to find/],
            :adv => [/closer to use tactical abilities/],
            :pause => [/still stunned|entangled in a web|Analyze what/],
            :continue => [/by landing a/] }
  result = match_get match

  case result[:key]
    when :wait, :fail
      pause 0.5
      analyze
    when :pause
      pause 3
      analyze
    when :adv
      advance
      analyze
    when :continue
      return result[:match]
  end
end

def extract_seq analyze_line
  analyze_line.gsub(/.*by landing|\ba\b|\./, '').split(/,|and/).collect(&:strip)
end

def do_maneuver maneuver
  put maneuver
  match = { :wait => [/\.\.\.wait/],
            :dead => COMBAT::MATCH_DEAD,
            :adv => [/aren't close enough/],
            :redo => [/evades,|dodges,|barely blocks with|A (\w|\s|'|-)+ of the (\w|\s|'|-)+ with/],
            :pause => [/still stunned|entangled in a web/],
            :continue => [/Roundtime/] }
  result = match_wait match

  case result
    when :wait, :redo
      pause 0.5
      do_maneuver maneuver
    when :pause
      pause 3
      do_maneuver maneuver
    when :adv
      advance
      do_maneuver maneuver
    when :dead
      load "skin.rb"
      face $args.first
      return :analyze
  end
end

def execute_seq maneuvers
  echo maneuvers
  maneuvers.each do |maneuver|
    case do_maneuver maneuver
      when :analyze
        break;
    end
  end
end

face $args.first
1000.times do
  hunt
  execute_seq extract_seq analyze
end