require "magic_logic/base"

module MagicLogic
  class Taut
    include Base
    def ~@;   $utout end
    def +(q); $tout  end
    def *(q); q      end
    def to_s; 'TRUE' end
  end
  $tout = Taut.new

  class UTaut
    include Base
    def ~@;   $tout   end
    def +(q); q       end
    def *(q); $utout  end
    def to_s; 'FALSE' end
  end
  $utout = UTaut.new

  class Atom < Struct.new(:p)
    include Base
    def ~@;   super   end
    def +(q); super   end
    def *(q); super   end
    def to_s; p.to_s  end

    class << self
      def [](x)
        new(x).tap { |p| $atoms << p; $atoms.uniq! }
      end
    end
  end
  P = Atom
  $atoms = []

  class NEG < Struct.new(:p)
    include Base
    def ~@;   super   end
    def +(q); super   end
    def *(q); super   end
    def to_s; "~#{p}" end
  end

  class FORM < Struct.new(:vars, :ope)
    include Base
    def initialize(vars, ope)
      self.vars = vars.map { |var| var.is_form?(ope) ? var.vars : var }.flatten
      self.ope = ope
    end
    def ~@;   super   end
    def +(q); super   end
    def *(q); super   end
    def to_s; "(#{vars.map(&:to_s).join(_ ope, '|', '&')})" end
  end

  class ::Array
    def >>(con)
      l = inject($tout) { |s, p| s * p } >= con
      case l.dpll
      when Taut  then 'TRUE'
      when UTaut then 'FALSE'
      else            'UNDECIDABLE'
      end
    end
  end
end
include MagicLogic
