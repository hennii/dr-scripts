# desc: pick boxes
# requirements: ?
# run: anywhere

@quick = false

if $args.join(" ").include? "quick"
  @quick = true;
end

@box_types = ["chest", "trunk", "box", "skippet", "strongbox", "coffer", "crate", "casket", "caddy"]
@finally_do = true

def finally_do
  if @finally_do
    pause_for_roundtime
    stow_lockpick
  end
end

def get_lockpick
  put "get lockpick from my shroud"
  wait
end

def stow_lockpick
  put "put lockpick in my shroud"
  wait
end

def ident
  put "pick ident"
  match = { :wait => [/\.\.wait|may only type ahead 1/],
            :get_pick => ["Find a more appropriate tool and try again!"],
            :end => ["not even locked"],
            :ident => ["teach you anything about the"],
            :blind => ["aged grandmother could open", "blindfolded"],
            :quick => ["junk barely worth your time", "a simple matter", "should not take long"],
            :normal => ["precisely at your", "only minor troubles", "has the edge on you", "have some chance of being able to"],
            :careful => ["odds are against you", "longshot", "amazingly minimal chance", "really don't have any"],
            :hard => ["prayer would be a good start", "snowball does", "jump off a cliff and",
                      "pitiful snowball encased", "just jump off a cliff"] }
  result = match_wait match

  case result
    when :wait, :ident
      pause 0.5
      ident
    when :get_pick
      get_lockpick
      ident
    when :end
      end_script "*** DONE ***"
      return
    when :hard
      exit_script("*** Unable to open! ***")
    else
      analyze result
  end
end

def analyze method
  put "pick analyze"
  match = { :wait => [/\.\.wait/],
            :get_pick => ["Find a more appropriate tool and try again!"],
            :analyze => ["You are unable to determine anything"],
            :continue => [/This lock has already helpfully been analyzed|roundtime/i] }
  result = match_wait match

  case result
    when :wait, :analyze
      pause 0.5
      analyze method
    when :get_pick
      get_lockpick
      analyze method
    when :continue
      pick method
  end
end

def pick method
  put "pick #{method}"
  match = { :wait => [/\.\.wait/],
            :end => ["It's not even locked, why bother?", "Roundtime"],
            :retry => ["unable to make any progress"],
            :ident => ["You discover another lock protecting"],
            :get_pick => ["Find a more appropriate tool and try again!"] }
  result = match_wait match

  case result
    when :wait, :retry
      pause 0.5
      pick method
    when :get_pick
      get_lockpick
      pick method
    when :ident
      ident
    when :end
      end_script "*** DONE ***"
      return
  end
end

def exit_script(message)
  echo message
  exit
end

def end_script(message)
  @finally_do = false
  echo message
  stow_lockpick
end

# start script

wield_right = Wield::right_noun
if !@box_types.any?{ |box_type| wield_right.include? box_type }
  exit_script("*** Need to be holding a box in the right hand! ***")
end

if !Wield::left_noun.include?("lockpick")
  get_lockpick
end

ident