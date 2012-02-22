# <penkovsky at mail dot ua>

module Normalizer    
    # Sanitizes (normalizes) word string.
    # Method should be also called before handlers
    # manipulate words.
    def normalize str
        
        # excluding alphabetical english and ukrainian, numerical and space symbols and asterix(wildcard) operator
        # unfortunately we can not yet use /i regexp directive for ukrainian symbols
        pattern = /[^a-zA-Z0-9АаБбВвГгҐґДдЕеЄєЖжЗзИиІіЇґЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЬьЮюЯя\s\*]*/
        # remove all unnecessary symbols
        str = str.gsub(pattern,'')
        
        if str.length > 2
            # remove last letter 's' (En plural)
            str = str.gsub(/s$/i,'')
        end
        
        # TODO downcase for ukrainian symbols
        return str.downcase
    end
    
    # normalizes list of words
    def normalize_list r
        res = []
        r.each do |el|
            if el.class == Array
                res.push normalize_list(el)
            else res.push normalize(el)
            end 
        end
        return res
    end
end
