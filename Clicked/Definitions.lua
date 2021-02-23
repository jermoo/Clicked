--- @class Clicked
--- @field public VERSION string
--- @field public RegisterEvent function
--- @field public UnregisterEvent function

--- @class ClickedInternal
--- @field SendCommMessage function
--- @field RegisterComm function
--- @field UnregisterAllComm function

--- @class Database
--- @field public RegisterCallback function
--- @field public UnregisterCallback function
--- @field public GetCurrentProfile function
--- @field public profile Profile

--- @class Profile
--- @field public version string
--- @field public options table
--- @field public options.onKeyDown boolean
--- @field public options.tooltips boolean
--- @field public options.minimap table
--- @field public options.minimap.hide boolean
--- @field public options.minimap.minimapPos number
--- @field public groups Group[]
--- @field public groups.next integer
--- @field public bindings Binding[]
--- @field public bindings.next integer
--- @field public blacklist string[]

--- @alias Localization table<string,string>

--- @class Binding
--- @field public type string
--- @field public identifier integer
--- @field public keybind string
--- @field public parent Group
--- @field public action table
--- @field public action.spellValue string
--- @field public action.itemValue string
--- @field public action.macroValue string
--- @field public action.macroMode string
--- @field public action.interrupt boolean
--- @field public action.allowStartAttack boolean
--- @field public action.cancelQueuedSpell boolean
--- @field public action.targetUnitAfterCast boolean
--- @field public targets table
--- @field public targets.hovercast Binding.Target
--- @field public targets.hovercast.enabled boolean
--- @field public targets.regular Binding.Target[]
--- @field public targets.regular.enabled boolean
--- @field public load Binding.Load
--- @field public integrations table<string,any>
--- @field public cache table<string,any>

--- @class Binding.Target
--- @field public unit string
--- @field public hostility string
--- @field public vitals string

--- @class Binding.Load
--- @field public never boolean
--- @field public class Binding.TriStateLoadOption
--- @field public race Binding.TriStateLoadOption
--- @field public playerNameRealm Binding.LoadOption
--- @field public combat Binding.LoadOption
--- @field public spellKnown Binding.LoadOption
--- @field public inGroup Binding.LoadOption
--- @field public playerInGroup Binding.LoadOption
--- @field public form Binding.TriStateLoadOption
--- @field public pet Binding.LoadOption
--- @field public instanceType Binding.TriStateLoadOption
--- @field public specialization Binding.TriStateLoadOption
--- @field public talent Binding.TriStateLoadOption
--- @field public pvpTalent Binding.TriStateLoadOption
--- @field public warMode Binding.LoadOption
--- @field public covenant Binding.TriStateLoadOption

--- @class Binding.LoadOption
--- @field public selected boolean
--- @field public value string

--- @class Binding.TriStateLoadOption
--- @field public selected "0"|"1"|"2"
--- @field public single number|string
--- @field public multiple number[]|string[]

--- @class Group
--- @field public name string
--- @field public displayIcon integer|string
--- @field public identifier string

--- @class Action
--- @field public ability integer|string
--- @field public combat string
--- @field public pet string
--- @field public forms string
--- @field public unit string
--- @field public hostility string
--- @field public vitals string

--- @class Command
--- @field public keybind string
--- @field public hovercast boolean
--- @field public action string
--- @field public data string
--- @field public prefix string
--- @field public suffix string

--- @class Keybind
--- @field public key string
--- @field public identifier string