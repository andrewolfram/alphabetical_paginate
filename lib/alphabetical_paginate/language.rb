# coding: utf-8
module AlphabeticalPaginate
  class Language
    APPROXIMATIONS = {
        "Э" => "je",
        "Ю" => "yu"
      }

    attr_reader :code

    def initialize(code)
      @code = code
    end

    def russian?
      defined?(I18n) && I18n.locale == :ru && code == :ru
    end

    def german?
      defined?(I18n) && I18n.locale == :de && code == :de
    end

    def letters_regexp
      russian? ? /[а-яА-Я]/ : ( german? ? /[a-zA-ZäöüÄÖÜß]/ : /[a-zA-Z]/ )
    end

    def slugged_regexp
      /^(#{slugged_letters.values.join("|")})$/
    end

    def default_letter
      russian? ? "а" : "a" # First 'a' is russian, second - english
    end

    # used in view_helper
    def letters_range
      if russian?
        letters = []
        #["А","Б","В","Г","Д","Е","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Э","Ю","Я"]
        "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯ".each_char{ |x| letters << x }
        letters
      elsif german?
        letters = []
        "AÄBCDEFGHIJKLMNOÖPQRSßTUÜVWXYZ".each_char{ |x| letters << x }
        letters
      else
        ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
      end
    end

    def slugged_letters
      hash = { "All" => "all" }
      letters_range.each{ |x| hash[x] = normalize(x) }
      hash
    end

    # used in view_helper
    def output_letter(l)
      (l == "All") ? all_field : l
    end

    # used in view_helper
    def all_field
      russian? ? 'Все' : (german? ? "Alle" : "All")
    end

    private

    def normalize(letter)
      if russian?
        APPROXIMATIONS[letter] || letter.to_s.to_slug.normalize(transliterations: :russian).to_s
      else
        letter.to_s.to_slug.normalize.to_s
      end
    end
  end
end
