require 'pp'

=begin
#Get last ran date

############################################################### TEST ADAPTATIONS #####################################
# Set the configuration path to test_config => will read ./test_config/config.yml
# Default is ./config.yml or config/config.yml
# ConfigFile.path="test_config"
ConfigFile.config_file="config.yml"

require 'rules/lirias_pre_pnx/parsing_rules.rb'
require 'rules/lirias_pre_pnx/writing_rules.rb'
############################################################### TEST ADAPTATIONS #####################################

from_date = CGI.escape(DateTime.parse(config[:last_run_updates]).xmlschema)
from_date_deleted = CGI.escape(DateTime.parse(config[:last_run_deletes]).xmlschema)
=end


=begin
Lirias_2_LIMO_types = {
  "c-editedbook"           => "book",
  "book"                   => "book",
  "design"                 => "design",
  "c-book"                 => "text_resource",
  "chapter"                => "book_chapter",
  "journal-article"        => "article",
  "conference"             => "conference_proceeding",
  "conference-proceedings" => "conference_proceeding",
  "dataset"                => "research_dataset",
  "thesis-dissertation"    => "dissertation",
  "c-bookreview"           => "review",
  "report"                 => "text_resource",
  "patent"                 => "patent"
}
=end


Lirias_2_LIMO_types = {
  "presentation"         => { :limo => "other", :ris => "ABS" },
  "book"                 => { :limo => "book", :ris => "BOOK"},
  "chapter"              => { :limo => "book_chapter", :ris => "CHAP" },
  "c-bookreview"         => { :limo => "review", :ris => "GEN" },
  "conference"           => { :limo => "conference_proceeding", :ris => "CONF" },
  "design"               => { :limo => "design", :ris => "ART" },
  "dataset"              => { :limo => "research_dataset", :ris => "DATA" },
  "c-editedbook"         => { :limo => "book", :ris => "EDBOOK" },
  "internet-publication" => { :limo => "other", :ris => "WEB" },
  "c-presentation"       => { :limo => "other", :ris => "GEN" },
  "journal-article"      => { :limo => "article", :ris => "JOUR" },
  "other"                => { :limo => "other", :ris => "GEN" },
  "patent"               => { :limo => "patent", :ris => "PAT" },
  "thesis-dissertation"  => { :limo => "dissertation", :ris => "THES" },
  "report"               => { :limo => "text_resource", :ris => "RPRT" },
  "media"                => { :limo => "text_resource", :ris => "GEN" },
  "software"             => { :limo => "other", :ris => "COMP" },
  "c-book"               => { :limo => "text_resource", :ris => "GEN" }
}




Lirias_2_languages = {

  "english"    => "eng",
  "en_us"      => "eng",
  "eng"        => "eng",
  "french"     => "fre",
  "fran??ais"   => "fre",
  "frans"      => "fre",  
  "dutch"      => "dut",
  "nederlands" => "dut",
  "flemish"    => "dut",
  "german"     => "ger",
  "deutsch"    => "ger",
  "duits"      => "ger",
  "spanish"    => "spa",
  "italian"    => "ita",  
  "portuguese" => "por",
  "russian"    => "rus",
  "polish"     => "pol",  
  "hungarian"  => "hun",
  "swedish"    => "swe",
  "hebrew"     => "heb",
  "konkani"    => "kok",
  "estonian"   => "est",
  "filipino"   => "fil",
  "pilipino"   => "fil",
  "finnish"    => "fin",
  "bengali"    => "ben",
  "icelandic"  => "ice",
  "romanian"   => "rum",
  "moldovan"   => "rum",
  "moldavian"  => "rum",
  
  "czech"      => "cze",
  "korean"     => "kor",
  "turkish"    => "tur",
  "norwegian"  => "nor",
  "georgian"   => "geo",
  "danish"     => "dan",
  "arabic"     => "ara",

  "catalan"    => "cat",
  "greek"      => "gre",
  "persian"    => "per",
  "uzbek"      => "uzb",
  "ukrainian"  => "ukr",
  "armenian"   => "arm",
  "latin"      => "lat",
  "latvian"    => "lav",
  "chinese"    => "chi",
  "castilian"  => "spa",
  "japanese"   => "jpn",
  "afrikaans"  => "afr",
  "croatian"   => "hrv",
  "slovak"     => "slo",
  "bulgarian"  => "bul",
  "slovenian"  => "slv",

  "other"      => "ukn",

  "?????????? ????????????, ????????????" => "abk",
  "ab" => "abk",
  "afaraf" => "aar",
  "aa" => "aar",
  "af" => "afr",
  "akan" => "aka",
  "ak" => "aka",
  "shqip" => "alb",
  "sq" => "alb",
  "????????????" => "amh",
  "am" => "amh",
  "ar" => "ara",
  "aragon??s" => "arg",
  "an" => "arg",
  "??????????????" => "arm",
  "hy" => "arm",
  "?????????????????????" => "asm",
  "as" => "asm",
  "???????? ????????, ???????????????? ????????" => "ava",
  "av" => "ava",
  "avesta" => "ave",
  "ae" => "ave",
  "aymar aru" => "aym",
  "ay" => "aym",
  "az??rbaycan dili, ????????????" => "aze",
  "az" => "aze",
  "bamanankan" => "bam",
  "bm" => "bam",
  "?????????????? ????????" => "bak",
  "ba" => "bak",
  "euskara, euskera" => "baq",
  "eu" => "baq",
  "???????????????????? ????????" => "bel",
  "be" => "bel",
  "???????????????" => "ben",
  "bn" => "ben",
  "bislama" => "bis",
  "bi" => "bis",
  "bosanski jezik" => "bos",
  "bs" => "bos",
  "brezhoneg" => "bre",
  "br" => "bre",
  "?????????????????? ????????" => "bul",
  "bg" => "bul",
  "???????????????" => "bur",
  "my" => "bur",
  "catal??, valenci??" => "cat",
  "ca" => "cat",
  "chamoru" => "cha",
  "ch" => "cha",
  "?????????????? ????????" => "che",
  "ce" => "che",
  "chiche??a, chinyanja" => "nya",
  "ny" => "nya",
  "?????? (zh??ngw??n), ??????, ??????" => "chi",
  "zh" => "chi",
  "?????????? ??????????" => "chv",
  "cv" => "chv",
  "kernewek" => "cor",
  "kw" => "cor",
  "corsu, lingua corsa" => "cos",
  "co" => "cos",
  "?????????????????????" => "cre",
  "cr" => "cre",
  "hrvatski jezik" => "hrv",
  "hr" => "hrv",
  "??e??tina, ??esk?? jazyk" => "cze",
  "cs" => "cze",
  "dansk" => "dan",
  "da" => "dan",
  "dv" => "div",
  "vlaams" => "dut",
  "nl" => "dut",
  "??????????????????" => "dzo",
  "dz" => "dzo",
  "en" => "eng",
  "esperanto" => "epo",
  "eo" => "epo",
  "eesti, eesti keel" => "est",
  "et" => "est",
  "e??egbe" => "ewe",
  "ee" => "ewe",
  "f??royskt" => "fao",
  "fo" => "fao",
  "vosa vakaviti" => "fij",
  "fj" => "fij",
  "suomi, suomen kieli" => "fin",
  "fi" => "fin",
  "fr" => "fre",
  "fulfulde, pulaar, pular" => "ful",
  "ff" => "ful",
  "galego" => "glg",
  "gl" => "glg",
  "?????????????????????" => "geo",
  "ka" => "geo",
  "de" => "ger",
  "????????????????" => "gre",
  "el" => "gre",
  "ava??e'???" => "grn",
  "gn" => "grn",
  "?????????????????????" => "guj",
  "gu" => "guj",
  "krey??l ayisyen" => "hat",
  "ht" => "hat",
  "(hausa) ????????????" => "hau",
  "ha" => "hau",
  "he" => "heb",
  "otjiherero" => "her",
  "hz" => "her",
  "??????????????????, ???????????????" => "hin",
  "hi" => "hin",
  "hiri motu" => "hmo",
  "ho" => "hmo",
  "magyar" => "hun",
  "hu" => "hun",
  "interlingua" => "ina",
  "ia" => "ina",
  "bahasa indonesia" => "ind",
  "id" => "ind",
  "(originally:) occidental, (after wwii:) interlingue" => "ile",
  "ie" => "ile",
  "gaeilge" => "gle",
  "ga" => "gle",
  "as???s??? igbo" => "ibo",
  "ig" => "ibo",
  "i??upiaq, i??upiatun" => "ipk",
  "ik" => "ipk",
  "ido" => "ido",
  "io" => "ido",
  "??slenska" => "ice",
  "is" => "ice",
  "italiano" => "ita",
  "it" => "ita",
  "??????????????????" => "iku",
  "iu" => "iku",
  "????????? (????????????)" => "jpn",
  "ja" => "jpn",
  "????????????, basa jawa" => "jav",
  "jv" => "jav",
  "kalaallisut, kalaallit oqaasii" => "kal",
  "kl" => "kal",
  "???????????????" => "kan",
  "kn" => "kan",
  "kanuri" => "kau",
  "kr" => "kau",
  "???????????????, ??????????" => "kas",
  "ks" => "kas",
  "?????????? ????????" => "kaz",
  "kk" => "kaz",
  "???????????????, ????????????????????????, ???????????????????????????" => "khm",
  "km" => "khm",
  "g??k??y??" => "kik",
  "ki" => "kik",
  "ikinyarwanda" => "kin",
  "rw" => "kin",
  "????????????????, ???????????? ????????" => "kir",
  "ky" => "kir",
  "???????? ??????" => "kom",
  "kv" => "kom",
  "kikongo" => "kon",
  "kg" => "kon",
  "?????????" => "kor",
  "ko" => "kor",
  "kurd??, ??????????" => "kur",
  "ku" => "kur",
  "kuanyama" => "kua",
  "kj" => "kua",
  "latine, lingua latina" => "lat",
  "la" => "lat",
  "l??tzebuergesch" => "ltz",
  "lb" => "ltz",
  "luganda" => "lug",
  "lg" => "lug",
  "limburgs" => "lim",
  "li" => "lim",
  "ling??la" => "lin",
  "ln" => "lin",
  "?????????????????????" => "lao",
  "lo" => "lao",
  "lietuvi?? kalba" => "lit",
  "lt" => "lit",
  "kiluba" => "lub",
  "lu" => "lub",
  "latvie??u valoda" => "lav",
  "lv" => "lav",
  "gaelg, gailck" => "glv",
  "gv" => "glv",
  "???????????????????? ??????????" => "mac",
  "mk" => "mac",
  "fiteny malagasy" => "mlg",
  "mg" => "mlg",
  "bahasa melayu, ???????? ??????????" => "may",
  "ms" => "may",
  "??????????????????" => "mal",
  "ml" => "mal",
  "malti" => "mlt",
  "mt" => "mlt",
  "te reo m??ori" => "mao",
  "mi" => "mao",
  "???????????????" => "mar",
  "mr" => "mar",
  "kajin m??aje??" => "mah",
  "mh" => "mah",
  "???????????? ??????" => "mon",
  "mn" => "mon",
  "dorerin naoero" => "nau",
  "na" => "nau",
  "din?? bizaad" => "nav",
  "nv" => "nav",
  "isindebele" => "nde",
  "nd" => "nde",
  "??????????????????" => "nep",
  "ne" => "nep",
  "owambo" => "ndo",
  "ng" => "ndo",
  "norsk bokm??l" => "nob",
  "nb" => "nob",
  "norsk nynorsk" => "nno",
  "nn" => "nno",
  "norsk" => "nor",
  "no" => "nor",
  "????????? nuosuhxop" => "iii",
  "ii" => "iii",
  "occitan, lenga d'??c" => "oci",
  "oc" => "oci",
  "????????????????????????" => "oji",
  "oj" => "oji",
  "?????????? ????????????????????" => "chu",
  "cu" => "chu",
  "afaan oromoo" => "orm",
  "om" => "orm",
  "???????????????" => "ori",
  "or" => "ori",
  "???????? ??????????" => "oss",
  "os" => "oss",
  "??????????????????, ????????????" => "pan",
  "pa" => "pan",
  "????????????, ????????????" => "pli",
  "pi" => "pli",
  "fa" => "per",
  "j??zyk polski, polszczyzna" => "pol",
  "pl" => "pol",
  "ps" => "pus",
  "portugu??s" => "por",
  "pt" => "por",
  "runa simi, kichwa" => "que",
  "qu" => "que",
  "rumantsch grischun" => "roh",
  "rm" => "roh",
  "ikirundi" => "run",
  "rn" => "run",
  "rom??n??, moldoveneasc??" => "rum",
  "ro" => "rum",
  "??????????????" => "rus",
  "ru" => "rus",
  "???????????????????????????, ????????????????????????????????????" => "san",
  "sa" => "san",
  "sardu" => "srd",
  "sc" => "srd",
  "???????????????, ????????" => "snd",
  "sd" => "snd",
  "davvis??megiella" => "sme",
  "se" => "sme",
  "gagana fa'a samoa" => "smo",
  "sm" => "smo",
  "y??ng?? t?? s??ng??" => "sag",
  "sg" => "sag",
  "???????????? ??????????" => "srp",
  "sr" => "srp",
  "g??idhlig" => "gla",
  "gd" => "gla",
  "chishona" => "sna",
  "sn" => "sna",
  "???????????????" => "sin",
  "si" => "sin",
  "sloven??ina, slovensk?? jazyk" => "slo",
  "sk" => "slo",
  "slovenski jezik, sloven????ina" => "slv",
  "sl" => "slv",
  "soomaaliga, af soomaali" => "som",
  "so" => "som",
  "sesotho" => "sot",
  "st" => "sot",
  "espa??ol" => "spa",
  "es" => "spa",
  "basa sunda" => "sun",
  "su" => "sun",
  "kiswahili" => "swa",
  "sw" => "swa",
  "siswati" => "ssw",
  "ss" => "ssw",
  "svenska" => "swe",
  "sv" => "swe",
  "???????????????" => "tam",
  "ta" => "tam",
  "??????????????????" => "tel",
  "te" => "tel",
  "????????????, to??ik??, ????????????" => "tgk",
  "tg" => "tgk",
  "?????????" => "tha",
  "th" => "tha",
  "????????????" => "tir",
  "ti" => "tir",
  "?????????????????????" => "tib",
  "bo" => "tib",
  "t??rkmen??e, t??rkmen dili" => "tuk",
  "tk" => "tuk",
  "wikang tagalog" => "tgl",
  "tl" => "tgl",
  "setswana" => "tsn",
  "tn" => "tsn",
  "faka tonga" => "ton",
  "to" => "ton",
  "t??rk??e" => "tur",
  "tr" => "tur",
  "xitsonga" => "tso",
  "ts" => "tso",
  "?????????? ????????, tatar tele" => "tat",
  "tt" => "tat",
  "twi" => "twi",
  "tw" => "twi",
  "reo tahiti" => "tah",
  "ty" => "tah",
  "ug" => "uig",
  "????????????????????" => "ukr",
  "uk" => "ukr",
  "ur" => "urd",
  "o??zbek, ??????????, ????????????" => "uzb",
  "uz" => "uzb",
  "tshiven???a" => "ven",
  "ve" => "ven",
  "ti???ng vi???t" => "vie",
  "vi" => "vie",
  "volap??k" => "vol",
  "vo" => "vol",
  "walon" => "wln",
  "wa" => "wln",
  "cymraeg" => "wel",
  "cy" => "wel",
  "wollof" => "wol",
  "wo" => "wol",
  "frysk" => "fry",
  "fy" => "fry",
  "isixhosa" => "xho",
  "xh" => "xho",
  "yi" => "yid",
  "yor??b??" => "yor",
  "yo" => "yor",
  "sa?? cue????, saw cuengh" => "zha",
  "za" => "zha",
  "isizulu" => "zul",
  "zu" => "zul",


}

=begin
Lirias_2_languages = {
  "dutch"      => "dut",
  "english"    => "eng",
  "french"     => "fre",
  "nederlands" => "dut",
  "spanish"    => "spa",
  "nl"         => "dut",
  "en_us"      => "eng",
  "eng"        => "eng",
  "en"         => "eng",
  "fr"         => "fre",
  "hungarian"  => "hun",
  "swedish"    => "swe",
  "hebrew"     => "heb",
  "konkani"    => "kok",
  "estonian"   => "est",
  "filipino"   => "fil",
  "pilipino"   => "fil",
  "finnish"    => "fin",
  "bengali"    => "ben",
  "icelandic"  => "ice",
  "romanian"   => "rum",
  "moldovan"   => "rum",
  "moldavian"  => "rum",
  "polish"     => "pol",
  "czech"      => "cze",
  "korean"     => "kor",
  "turkish"    => "tur",
  "norwegian"  => "nor",
  "georgian"   => "geo",
  "danish"     => "dan",
  "arabic"     => "ara",
  "russian"    => "rus",
  "portuguese" => "por",
  "german"     => "ger",
  "italian"    => "ita",
  "catalan"    => "cat",
  "greek"      => "gre",
  "persian"    => "per",
  "uzbek"      => "uzb",
  "ukrainian"  => "ukr",
  "armenian"   => "arm",
  "latin"      => "lat",
  "latvian"    => "lav",
  "chinese"    => "chi",
  "castilian"  => "spa",
  "japanese"   => "jpn",
  "afrikaans"  => "afr",
  "croatian"   => "hrv",
  "slovak"     => "slo",
  "bulgarian"  => "bul",
  "slovenian"  => "slv"
}
=end

Format_mean = {
  "archival_material" => "archival_materials",
  "archival_material_manuscript" => "archival_material_manuscripts",
  "edited_book" => "edited_books",
  "newspaper" => "newspapers",
  "computer_file" => "computer_files",
  "journalissue" => "journalissues",
  "offprint" => "articles",
  "patent" => "patents",
  "text_resource" => "text_resources",
  "article" => "articles",
  "other" => "other",
  "journal" => "journals",
  "image" => "images",
  "score" => "scores",
  "audio" => "audios",
  "web_resource" => "web_resources",
  "book" => "books",
  "review" => "reviews",
  "book_chapter" => "book_chapters",
  "internal_report" => "internal_reports",
  "audio-visual" => "audio_visual",
  "conference" => "conferences",
  "chapter" => "book_chapters",
  "game" => "games",
  "standard" => "standards",
  "schoolbook" => "schoolbooks",
  "manuscript" => "manuscripts",
  "external_report" => "external_reports",
  "legal_document" => "legal_documents",
  "video" => "videos",
  "map" => "maps",
  "database" => "databases",
  "statistical_data_set" => "statistical_data_sets",
  "conference_proceeding" => "conference_proceedings",
  "dissertation" => "dissertations",
  "reference_entry" => "reference_entrys",
  "rare_book" => "rare_books",
  "newspaper_article" => "newspaper_articles",
  "government_document" => "government_documents",
  "collection" => "collections",
  "dataset" => "datasets",
  "microform" => "microform"
}


def create_person(person)
  unless person["identifiers"].nil?
    person["identifiers"] = person["identifiers"]["identifier"]
    person["identifiers"] = [ person["identifiers"] ] unless person["identifiers"].is_a?(Array)
    person["identifiers"].map! { |i|
      { i.attributes["scheme"].to_sym =>  i }
    }
    person["identifiers"] << { :staff_nbr =>  person["username"] } unless person["username"].nil?
  else
    person["identifiers"] = [{ :staff_nbr =>  person["username"] }] unless person["username"].nil?
  end
  person.delete("username");
  person["name"] = "#{person["last_name"]}, #{person["first_names"]}";
  person
end


def create_person_display(person)
  if person["function"].nil?
    "#{person["last_name"]}, #{person["first_names"]}$$Q#{person["last_name"]}, #{person["first_names"]}"
   else
     "#{person["last_name"]}, #{person["first_names"]} (#{person["function"].uniq.join(', ')})$$Q#{person["last_name"]}, #{person["first_names"]}"
   end
end

def create_person_addlink(expanded_person)
  addlink = []
  # staff_nbr_link
  ids = expanded_person.map { |person|
    unless person["identifiers"].nil?
      person["identifiers"].map { |i|
        unless  i[:staff_nbr].nil?
          "#{person["last_name"]}, #{person["first_names"]} [KU Leuven ID]$$Uhttps://www.kuleuven.be/wieiswie/en/person/#{i[:staff_nbr]}"
        end
      }
    end
  }
  unless ids.nil?
    addlink.concat ids
    addlink.flatten!
  end

  # researcherid_link
  ids = expanded_person.map { |person|
    unless person["identifiers"].nil?
      person["identifiers"].map { |i|
        unless  i[:researcherid].nil?
          "#{person["last_name"]}, #{person["first_names"]} [ResearcherID]$$Uhttps://www.researcherid.com/rid/#{i[:researcherid]}"
        end
      }
    end
  }
  unless ids.nil?
    addlink.concat ids
    addlink.flatten!
  end

  # orcid_link
  ids = expanded_person.map { |person|
    unless person["identifiers"].nil?
      person["identifiers"].map { |i|
        if  i[:orcid].nil?
          nil
        else
          "#{person["last_name"]}, #{person["first_names"]} [ORCID]$$Uhttps://orcid.org/#{i[:orcid]}"
        end
      }
    end
  }
  unless ids.nil?
    addlink.concat ids
    addlink.flatten!
  end

  addlink.compact

end


def PrimoVE_create_tar(tarfilename, directory_to_tar)
  c_dir = Dir.pwd
  if Dir.exist?(directory_to_tar) 
    log("INFO Start tar cd #{directory_to_tar}; tar -czf #{tarfilename}  primoVE_*.json; cd #{c_dir}")

    tar_resp = `cd #{directory_to_tar}; tar -czf #{tarfilename} primoVE_*.json; cd #{c_dir}`

    if $?.exitstatus != 0
      log("ERROR in creating tar.gz")
    else
      log ("REMOVE: #{directory_to_tar}/primoVE_*.json ")

      Dir.glob("#{directory_to_tar}/primoVE_*.json").each { |f| File.delete(f) }
    end
  end
end




def collect_records()
  begin

    # puts "START COLLECTION RECORDS lirias_pre_pnx_rules !!   2 dagen aan gewerkt 15/10 en 18/10 en nog enkele uren op 27/10"
    last_affected_when  = config[:last_run_updates]
    deleted_when        = config[:last_run_deletes]

    from_date          = CGI.escape(DateTime.parse(last_affected_when).xmlschema)
    from_date_deleted  = CGI.escape(DateTime.parse(deleted_when).xmlschema)

    url         = "#{config[:base_url]}#{ from_date  }"
    url_delete  = "#{config[:base_delete_url]}#{ from_date_deleted }"
    url_options = {user: config[:user], password: config[:password]}

    records_dir        = config[:records_dir]          || "test_records"
    record_template    = config[:record_template]      || "lirias_pre_pnx_template.erb"
    delete_template    = config[:delete_template]      || "lirias_delete_template.erb"


    max_updated_records  = config[:max_updated_records] || 1000
    max_deleted_records  = config[:max_deleted_records] || 50
    tar_records          = config[:tar_records]         || true
    one_xml_file         = config[:one_xml_file]        || false
    remove_temp_files    = config[:remove_temp_files]   || true
    debugging            = config[:debugging]           || false

    unless records_dir.chr == "/"
      records_dir = "#{File.dirname(__FILE__)}/../#{records_dir}"
    end


=begin
#Create starting URL
  url = "#{config[:base_url]}#{from_date}"
  url_delete = "#{config[:base_delete_url]}#{from_date_deleted}"

  options = {user: config[:user], password: config[:password]}

  last_affected_when = config[:last_run_updates]
  deleted_when  = config[:last_run_deletes]

  c_dir = Dir.pwd
  ############################################################### TEST ADAPTATIONS #####################################
  #records_dir = "test_records"
  #records_dir = "/home/limo/dCollector/records"
  records_dir = "#{c_dir}/records"

  counter = 0
  dcounter = 0
  updated_records = 0
  max_updated_records = 500000
  deleted_records = 0
  max_deleted_records = 50000
  tar_records = true

  debugging = false

  if debugging
    max_updated_records = 1000
    max_deleted_records = 50
    tar_records = true
    #url = 'file://mock.xml'
    #url = 'https://lirias2repo.kuleuven.be/elements-cache/rest/publications?affected-since=2018-10-17T21%3A51%3A42.690Z&per-page=50'
    #url = 'file://bronbestanden/call_622.xml'
    #url_delete = nil

  end
=end

    counter = 0
    dcounter = 0
    updated_records = 0
    deleted_records = 0

    # More about jsonpath
    #https://www.pluralsight.com/blog/tutorials/introduction-to-jsonpath
    #url = "https://lirias2test.libis.kuleuven.be/elements-cache/rest/publications?per-page=10&affected-since=2018-03-14T20%3A44%3A14%2B01%3A00"

    log("Get Data affected-since #{from_date} ")

    #url ="file://test_records/call_215.xml"
    #url ="file://test_records/call_321.xml"
    #url ="file://test_records/medium.xml"
    #url ="file://test_records/orcid.xml"
    #url ="file://test_records/edition.xml"
    #url ="file://test_records/series.xml"
    #url ="file://test_records/new_credit_roles.xml"


    while url
      log("Load URL : #{  url }")

      timing_start = Time.now
      #Load data
      data = input.from_uri(url, url_options)
      log("Data loaded in #{((Time.now - timing_start) * 1000).to_i} ms")

      tmp_records_dir = "#{records_dir}/records_#{Time.now.to_i}"
      tmp_not_claimed_records_dir = "#{records_dir}/records_not_claimed_#{Time.now.to_i}"

      resolver_data = {}
      resolver_authors = {}
      resolver_data_not_claimed_lirias_records = []

      timing_start = Time.now
      #Filter on Object

      filter(data, '$..entry[*].object').each do |object|
        ######################### Parse_record ###  rules/test_lirias_pre_pnx/parsing_rules.rb ######
        parse_record(object)

  #  puts output.raw()[:correction_to]
  #  puts output.raw()[:correction_from]
  #  puts output.raw()[:derivative_to]
  #  puts output.raw()[:derivative_from]
  #  puts output.raw()[:supplement_to]
  #  puts output.raw()[:supplement_from]
  #  puts output.raw()[:supersedes_to]
  #  puts output.raw()[:supersedes_from]

#        log ("id: #{output.raw()[:id]} last_affected_when #{output[:updated] }")

        log("-- source --") if debugging
        output.raw()[:source] = "lirias"
        output.raw()[:sourceid] =  "lirias"
        output.raw()[:sourcerecordid] = output.raw()[:id]
        output.raw()[:recordid] = output.raw()[:sourceid] + output.raw()[:id].first
        output.raw()[:id] = output.raw()[:id].first

        # log("INFO id : #{  output.raw()[:recordid]  }  ")
        if  output[:deleted]
          dcounter += 1
           ##########       log("INFO id : #{    output[:id] } Not Claimed")
          #log("INFO output :-------------------------------------------")
          #log("INFO output : #{    output.raw }")
          #log("INFO output :-------------------------------------------")

          #output.to_tmp_file("templates/lirias_delete_template.erb",tmp_not_claimed_records_dir)
          #output.to_tmp_file(delete_template,tmp_records_dir)
          output.to_jsonfile(output.raw(), "primoVE_#{output.raw()[:id]}",records_dir)
          resolver_data_not_claimed_lirias_records << output.raw.slice(:id, :deleted, :response_date)
        else
          last_affected_when = output[:updated][0]

          #output.to_tmp_file("templates/lirias_pre_pnx_template.erb",tmp_records_dir)
          #output.raw()[:source] = "lirias"
          #output.raw()[:sourceid] =  "lirias"
          #output.raw()[:sourcerecordid] = output.raw()[:id]
          #output.raw()[:recordid] = output.raw()[:sourceid] + output.raw()[:id].first
          #output.raw()[:id] = output.raw()[:id].first

          # output.raw()[:sourceformat] =  "???????"
          #cotrol section contains a field score !!!!!!!

          log("-- relationship --") if debugging
          output.raw()[:relationship] = {}
          unless output.raw()[:correction_from].nil? && output.raw()[:correction_to].nil?
            output.raw()[:relationship][:correction] = {}
            output.raw()[:relationship][:correction][:from] = output.raw()[:correction_from].map{ |i| {:id => i }} unless output.raw()[:correction_from].nil?
            output.raw()[:relationship][:correction][:to] = output.raw()[:correction_to].map{ |i| {:id => i }} unless output.raw()[:correction_to].nil?
          end
          unless output.raw()[:derivative_from].nil? && output.raw()[:derivative_to].nil?
            output.raw()[:relationship][:derivative] = {}
            output.raw()[:relationship][:derivative][:from] = output.raw()[:derivative_from].map{ |i| {:id => i }} unless output.raw()[:derivative_from].nil?
            output.raw()[:relationship][:derivative][:to] = output.raw()[:derivative_to].map{ |i| {:id => i }} unless output.raw()[:derivative_to].nil?
          end
          unless output.raw()[:supplement_from].nil? && output.raw()[:supplement_to].nil?
            output.raw()[:relationship][:supplement] = {}
            output.raw()[:relationship][:supplement][:from] = output.raw()[:supplement_from].map{ |i| {:id => i }} unless output.raw()[:supplement_from].nil?
            output.raw()[:relationship][:supplement][:to] = output.raw()[:supplement_to].map{ |i| {:id => i }} unless output.raw()[:supplement_to].nil?
          end
          unless output.raw()[:supersedes_from].nil? && output.raw()[:supersedes_to].nil?
            output.raw()[:relationship][:supersedes] = {}
            output.raw()[:relationship][:supersedes][:from] = output.raw()[:supersedes_from].map{ |i| {:id => i }} unless output.raw()[:supersedes_from].nil?
            output.raw()[:relationship][:supersedes][:to] = output.raw()[:supersedes_to].map{ |i| {:id => i }} unless output.raw()[:supersedes_to].nil?
          end

          output.raw()[:relationship].compact!
          output.raw().delete(:relationship) if output.raw()[:relationship].empty?

          log("-- local_field_07 --") if debugging
          # PNX - local_field_07 (genre form)
          output.raw()[:local_field_07] = output.raw()[:type].clone()
          # pp output.raw()[:local_field_07]
          ##  if type is not defined in Lirias_2_LIMO_types => { :limo => "other", :ris => "GEN" },
          output.raw()[:ristype] = output.raw()[:type].map { |t| Lirias_2_LIMO_types[t].nil? ? "GEN" :   Lirias_2_LIMO_types[t][:ris] }

          # PNX - type
          log("-- type --") if debugging
          ##  if type is not defined in Lirias_2_LIMO_types => { :limo => "other", :ris => "GEN" },
          output.raw()[:type].map! { |t| Lirias_2_LIMO_types[t].nil? ? "other" :   Lirias_2_LIMO_types[t][:limo] }

          if output.raw()[:type].length != 1
            log(" Issue with records type #{  output.raw()[:type] } in id #{  output.raw()[:id] }")
          else
            if output.raw()[:type].first.nil?
              output.raw()[:type] = "other"
            else
              output.raw()[:type] = output.raw()[:type].first
            end
          end
          #pp output.raw()[:type]

          output.raw()[:addlink]  = []
          log("-- creator --") if debugging
          # PNX - creator
          unless output.raw()[:author].nil?

            output.raw()[:creator] = output.raw()[:author].clone()
            output.raw()[:creator].map! { |person| create_person(person) }

            # output.raw()[:creator] = output.raw()[:author].map { |person| create_person_display(person) }
            output.raw()[:addlink].concat create_person_addlink( output.raw()[:creator] )

          end
          # pp output.raw()[:creator]
          # pp output.raw()[:expanded_creator]
          # pp output.raw()[:addlink]

          # PNX - contributor
          log("-- contributor --") if debugging
          unless output.raw()[:contributor].nil?

            #output.raw()[:expanded_contributor] = output.raw()[:contributor].clone()
            #output.raw()[:expanded_contributor].map! { |person| create_person(person) }
            #output.raw()[:contributor].map! { |person| create_person_display(person) }
            #output.raw()[:addlink].concat create_person_addlink( output.raw()[:expanded_contributor] )

            output.raw()[:contributor].map! { |person| create_person(person) }
            output.raw()[:addlink].concat create_person_addlink( output.raw()[:contributor] )

          end
          #pp  output.raw()[:contributor]
          #pp  output.raw()[:expanded_contributor]
          log("-- facet_creator_contributor --") if debugging
          output.raw()[:facets_creator_contributor] = []
          output.raw()[:facets_creator_contributor].concat output.raw()[:creator].map { |p| p["name"] } unless output.raw()[:creator].nil?

          output.raw()[:facets_creator_contributor].concat output.raw()[:creator].map { |p|
            p["identifiers"].map { |i|
              i[:staff_nbr]
            }.select { |s| !s.nil? }.flatten unless  p["identifiers"].nil?
          }.select { |s| !s.nil? }.flatten unless output.raw()[:creator].nil?

          output.raw()[:facets_creator_contributor].concat output.raw()[:contributor].map { |p| p["name"] } unless output.raw()[:contributor].nil?
          output.raw()[:facets_creator_contributor].concat output.raw()[:contributor].map { |p|
            p["identifiers"].map { |i|
              i[:staff_nbr]
            }.select { |s| !s.nil? }.flatten unless  p["identifiers"].nil?
          }.select { |s| !s.nil? }.flatten unless output.raw()[:contributor].nil?

          #pp output.raw()[:addlink]

          # PNX - edition / version (local_field_12) ???
          log("-- edition --") if debugging
          unless output.raw()[:edition].nil? && output.raw()[:version].nil?
            if output.raw()[:parent_title].nil? && output.raw()[:journal].nil?
              if output.raw()[:edition].nil?
                output.raw()[:edition] = output.raw()[:version]
              else
                output.raw()[:edition].push ( output.raw()[:version] ) unless output.raw()[:version].nil?
              end
            else
              output.raw()[:edition] = nil
            end
          end
          # pp output.raw()[:edition]

          # PNX - publisher
          log("-- publisher  --") if debugging
          unless output.raw()[:place_of_publication].nil?
            output.raw()[:publisher].map! { |p| p + "; " + output.raw()[:place_of_publication].uniq.join(', ') } unless  output.raw()[:publisher].nil?
          end
          # pp  output.raw()[:publisher]

          # PNX - creationdate, search_creationdate, search_startdate, search_enddate
          # For display the date format is yyyy-mm, exception dissertation:foramt is yyyy-mm-dd
          # Do not set a creation date if the field journal or parent_title exists in the record
          # pp output.raw()[:publication_date]

          log("-- search_creationdate  --") if debugging
          output.raw()[:search_creationdate] = []
          if output.raw()[:publication_date].nil?
            if output.raw()[:online_publication_date].nil?
              output.raw()[:search_creationdate].concat output.raw()[:acceptance_date].map { |d| d.gsub(/[-\/\.]/, '') } ||[] unless  output.raw()[:acceptance_date].nil?
            else
              output.raw()[:search_creationdate].concat output.raw()[:online_publication_date].map { |d| d.gsub(/[-\/\.]/, '') }
            end
          else
            output.raw()[:search_creationdate].concat output.raw()[:publication_date].map { |d| d.gsub(/[-\/\.]/, '') }
          end
          unless output.raw()[:search_creationdate].empty?
            output.raw()[:risdate] = output.raw()[:search_creationdate]
            output.raw()[:search_startdate] = output.raw()[:search_creationdate].map { |d| d.gsub(/(\d{4})(\d{4})/, '\10101') }
            output.raw()[:search_enddate] = output.raw()[:search_creationdate].map { |d| d.gsub(/(\d{4})(\d{4})/, '\11231') }
            unless output.raw()[:journal].nil? && output.raw()[:parent_title].nil?
              output.raw()[:creationdate] = output.raw()[:search_creationdate].map { |d| d.gsub(/([\d]{4})([\d]{2})([\d]{2})/, '\1-\2') }
              if output.raw()[:type] === 'dissertation'
                output.raw()[:creationdate] = output.raw()[:search_creationdate].map { |d| d.gsub(/([\d]{4})([\d]{2})([\d]{2})/, '\1-\2-\3') }
              end
            end
          end
          # pp output.raw()[:search_creationdate]
          # pp output.raw()[:search_startdate]
          # pp output.raw()[:search_enddate]
          # pp output.raw()[:creationdate]

          # PNX - format
          log("-- format  --") if debugging
          unless output.raw()[:medium].nil?
            if output.raw()[:number_of_pages].nil?
              output.raw()[:format] = output.raw()[:medium]
            else
              output.raw()[:format] = output.raw()[:medium].map { |m| m + " page(s): " + output.raw()[:number_of_pages].uniq.join(', ')  }
            end
          end
          # pp output.raw()[:format]

          # PNX - ispartof
          log("-- ispartof  --") if debugging
          unless output.raw()[:journal].nil?
              output.raw()[:ispartof] = output.raw()[:journal].clone()
              output.raw()[:journal_title] = output.raw()[:journal].clone()
          end
          unless output.raw()[:parent_title].nil?
            output.raw()[:ispartof] = output.raw()[:parent_title]
          end
          unless output.raw()[:journal].nil? && output.raw()[:parent_title].nil?
            unless output.raw()[:search_creationdate].nil?
              date = output.raw()[:search_creationdate].map{ |d| d.gsub(/(\d{4})[\d-]*/, '\1') }.uniq.join(', ')
              output.raw()[:ispartof].map! { |p| p + "; " + date }
            end
            unless output.raw()[:edition].nil?
              edition = output.raw()[:edition].uniq.join(', ')
              output.raw()[:ispartof].map! { |p| p + "; Edition: " + edition }
            end
            unless output.raw()[:volume].nil?
              volume = output.raw()[:volume].uniq.join(', ')
              output.raw()[:ispartof].map! { |p| p + "; Vol. " + volume }
            end
            unless output.raw()[:issue].nil?
              issue = output.raw()[:issue].uniq.join(', ')
              output.raw()[:ispartof].map! { |p| p + "; iss. " + issue }
            end
            unless output.raw()[:pagination].nil?
              # pp  output.raw()[:pagination]
              output.raw()[:pagination].map! { |p|
                unless p["begin_page"].nil? && p["end_page"].nil?
                  p_begin = "..."
                  p_end   = "..."
                  p_begin =  p["begin_page"] unless  p["begin_page"].nil?
                  p_end   =  p["end_page"] unless  p["end_page"].nil?
                  p["pagination"] = "#{p_begin} - #{p_end}"
                end
                p
              }
              pagination =  output.raw()[:pagination].map { |p|  p["pagination"] } .uniq.join(', ')
              output.raw()[:ispartof].map! { |p| p + "; pp. " + pagination }
            end
          end
          if output.raw()[:type] === 'chapter'
            chapter = output.raw()[:number].uniq.join(', ')
            output.raw()[:ispartof].map! { |p| p + "; Chapter Nr. " + chapter }
          end
          # pp output.raw()[:ispartof]


          output.raw()[:book_title] = output.raw()[:parent_title] || []

         # if ["chapter","journal-article","conference"].include?( output.raw()[:type] )
          if ["chapter","book_chapter","journal-article","article","conference","conference_proceeding"].include?( output.raw()[:type] )
            output.raw()[:article_title] = output.raw()[:title]
          else
            output.raw()[:book_title].concat output.raw()[:title] unless output.raw()[:title].nil?
          end


          # PNX - identifiers
          log("-- indetitiers  --") if debugging
          output.raw()[:identifiers] = []
          output.raw()[:identifiers].concat output.raw()[:isbn_10].map { |i| "$$CISBN:$$V" + i } unless output.raw()[:isbn_10].nil?
          output.raw()[:identifiers].concat output.raw()[:isbn_13].map { |i| "$$CISBN:$$V" + i } unless output.raw()[:isbn_13].nil?
          output.raw()[:identifiers].concat output.raw()[:issn].map { |i| "$$CISSN:$$V" + i } unless output.raw()[:issn].nil?
          output.raw()[:identifiers].concat output.raw()[:eissn].map { |i| "$$CEISSN:$$V" + i } unless output.raw()[:eissn].nil?
          output.raw()[:identifiers].concat output.raw()[:doi].map { |i| "$$CDOI:$$V" + i } unless output.raw()[:doi].nil?
          output.raw()[:identifiers] << "$$CPMID:$$V" + output.raw()[:pmid]  unless output.raw()[:pmid].nil?
          output.raw()[:identifiers] << "$$CWOSID:$$V" + output.raw()[:wosid] unless output.raw()[:wosid].nil?
          output.raw()[:identifiers] << "$$CSCOPUSID:$$V" + output.raw()[:scopusid]  unless output.raw()[:scopusid].nil?
          output.raw()[:identifiers].concat output.raw()[:external_identifiers].map { |i| "$$Cexternal_identifiers:$$V" + i } unless output.raw()[:external_identifiers].nil?
          output.raw()[:identifiers].concat output.raw()[:patent_number].map { |i| "$$Cpatent_number:$$V" + i } unless output.raw()[:patent_number].nil?
          # pp  output.raw()[:identifiers]

          # PNX - Subject
          log("-- keywords  --") if debugging
          unless output.raw()[:keyword].nil?
            #output.raw()[:subject] = output.raw()[:keyword].uniq.sort 
            output.raw()[:subject] = output.raw()[:keyword].uniq
          end
          # pp  output.raw()[:subject]

          # PNX - description
          output.raw()[:description] = output.raw()[:abstract]
          # pp  output.raw()[:description]

          # PNX - language ????????
          output.raw()[:language].map! { |t| Lirias_2_languages[t.downcase] || t }  unless output.raw()[:language].nil?
          # pp  output.raw()[:language]

          # PNX - relation
          log("-- relation  --") if debugging

          output.raw()[:relation] = output.raw()[:serie] unless output.raw()[:serie].nil?
          unless output.raw()[:relation].nil?
            output.raw()[:relation].map! { |e| e + ", Date: " + output.raw()[:start_date].uniq.join(', ').gsub(/-/, '/') } unless output.raw()[:start_date].nil?
            output.raw()[:relation].map! { |e| e + " - " + output.raw()[:finish_date].uniq.join(', ').gsub(/-/, '/') } unless output.raw()[:finish_date].nil?
            output.raw()[:relation].map! { |e| e + ", Location: " + output.raw()[:location].uniq.join } unless output.raw()[:location].nil?
          end
          # pp  output.raw()[:relation]

          # PNX - vertitle
          output.raw()[:vertitle] = output.raw()[:alternative_title] unless output.raw()[:alternative_title].nil?
          # pp  output.raw()[:vertitle]

          # PNX - notes
          log("-- notes  --") if debugging
          output.raw()[:notes] = output.raw()[:funding_acknowledgements] unless output.raw()[:funding_acknowledgements].nil?
          output.raw()[:local_field_11] = output.raw()[:funding_acknowledgements] unless output.raw()[:funding_acknowledgements].nil?
          # pp  output.raw()[:notes]

          # PNX - event (lds02) => local_field_02
          # https://ecb.limo.q.libis.be/primaws/rest/pub/translations/49ECB_INST:ECB?lang=en
          #   fulldisplay.event: "Event Information" ==> local_field_02 mss niet nodig
          unless output.raw()[:name_of_conference].nil?
            output.raw()[:event] = output.raw()[:name_of_conference]
            output.raw()[:event].map! { |e| e + ", Date: " + output.raw()[:start_date].uniq.join(', ').gsub(/-/, '/') } unless output.raw()[:start_date].nil?
            output.raw()[:event].map! { |e| e + " - " + output.raw()[:finish_date].uniq.join(', ').gsub(/-/, '/') } unless output.raw()[:finish_date].nil?
            output.raw()[:event].map! { |e| e + ", Location: " + output.raw()[:location].uniq.join } unless output.raw()[:location].nil?
            output.raw()[:event].map! { |e| e + ", " + output.raw()[:venue_designart].uniq.join(', ') } unless output.raw()[:venue_designart].nil?
          end
          output.raw()[:local_field_02] = output.raw()[:event]
          # pp  output.raw()[:event]

          # PNX - local_field_08 (lds12) => publication_status
          log("-- local_field_08  --") if debugging
          unless output.raw()[:publication_status].nil?
            output.raw()[:local_field_08] = output.raw()[:publication_status]
          else
            output.raw()[:local_field_08] = output.raw()[:patent_status] unless output.raw()[:patent_status].nil?
          end

          # PNX - local_field_09 (lds29) => Invited by
          log("-- local_field_09  --") if debugging
          output.raw()[:local_field_09] = output.raw()[:invitedby] unless output.raw()[:invitedby].nil?

          # PNX - local_field_10 (lds30) => Virtual collection
          log("-- local_field_10  --") if debugging
          output.raw()[:local_field_10] = []
          output.raw()[:local_field_10].concat output.raw()[:virtual_collections] unless output.raw()[:virtual_collections].nil?
          #output.raw()[:local_field_10].concat output.raw()[:historic_collection].map { |h| h.gsub(/(.*)(;)(.*)/, '\1') } unless output.raw()[:historic_collection].nil?

          output.raw()[:local_facet_10] = output.raw()[:local_field_10].clone()
          output.raw()[:local_facet_10].concat  output.raw()[:organizational_unit]  unless output.raw()[:organizational_unit].nil?

          # PNX - local_field_ (lds14) => RecordId
          # PNX - local_field_ (lds50) => Peer Reviewed  ??????????????????????

          # PNX - oa
          # output.raw()[:oa] = "free_for_read"
          # PNX - rsrctype

          # PNX - Links backlink
          log("-- backlink  --") if debugging
          output.raw()[:backlink] =  output.raw()[:public_url].map { |u|
             unless u.match(/\/bitstream\/|\/retrieve\//)
              "$$U#{u}$$Ebacklink_lirias"
            end
          }
          # pp output.raw()[:backlink]

          # PNX - Links linktorsrc
          log("-- linktorsrc  --") if debugging
          output.raw()[:linktorsrc] = []
          output.raw()[:linktorsrc].concat output.raw()[:publisher_url].map { |u| "$$U#{u}" } unless  output.raw()[:publisher_url].nil?
          output.raw()[:linktorsrc].concat output.raw()[:additional_identifier].map { |ai|
            if ai.match(/^http:/)
             "$$U#{ai}"
            end
          } unless output.raw()[:additional_identifier].nil?

          unless output.raw()[:files].nil?
            output.raw()[:files].map! { |file|
              file["public_access"] =  file["filePublic"]
              file["intranet_access"] =  file["fileIntranet"]
              file
            }

            output.raw()[:linktorsrc].concat  output.raw()[:files].map { |file|
              restriction = nil
              if file["filePublic"]
                restriction ="freely available"
              else
                if file["fileIntranet"]
                  restriction = "Available for KU Leuven users"
                  if file["embargo_release_date"]
                    unless file["embargo_release_date"].to_s.match(/^9999/)
                      restriction = "Available for KU Leuven users - Embargoed until #{file["embargo_release_date"]}"
                    end
                  end
                end
              end

              if file.has_key?("description") && file["description"].present? && !['Accepted version', 'Published version', 'Submitted version', 'Supporting version'].include?(file["description"])
                desc = file["description"]
              else
                desc = file["filename"]
              end

              unless restriction.nil?
                "$$U#{file["file_url"]}$$D#{desc} [#{restriction}]"
              end
            }
          end
          # pp output.raw()[:linktorsrc]

          # PNX - delivery_delcategory
          log("-- delivery_delcategory  --") if debugging
          if !output.raw()[:files].nil? && output.raw()[:files].any? { |file| file["file_url"] }
            output.raw()[:delivery_delcategory] = "Online Resource"
            output.raw()[:delivery_fulltext] = "fulltext_linktorsrc"

          elsif output.raw()[:issn] || output.raw()[:isbn] || output.raw()[:doi]
            output.raw()[:delivery_delcategory] = "Remote Search Resource"
            output.raw()[:delivery_fulltext] = "fulltext_unknown"
          elsif output.raw()[:publisher_url]
            output.raw()[:delivery_delcategory] = "Online Resource"
            output.raw()[:delivery_fulltext] = "fulltext_linktorsrc"
          elsif !output.raw()[:additional_identifier].nil? && output.raw()[:additional_identifier].any?  { |ai|  ai.match(/^http/) }
            output.raw()[:delivery_delcategory] = "Online Resource"
            output.raw()[:delivery_fulltext] = "fulltext_linktorsrc"
          else
            output.raw()[:delivery_delcategory] = "Remote Search Resource"
            output.raw()[:delivery_fulltext] = "no_fulltext"
          end
          # pp output.raw()[:delivery_delcategory]

          # PNX - delivery_resdelscope
          log("-- delivery_resdelscope  --") if debugging
          if !output.raw()[:files].nil? && output.raw()[:files].none? { |file| file["public_access"] == true } &&  output.raw()[:delivery_delcategory] == "Online Resource"
            output.raw()[:delivery_resdelscope] = "RESLIRIAS"
          end
          # pp output.raw()[:delivery_resdelscope]

          # facets_toplevel
          log("-- facets_toplevel  --") if debugging
          output.raw()[:facets_toplevel] = []
          unless output.raw()[:peer_reviewed].nil?
            if output.raw()[:peer_reviewed].any? { |s| s.match(/^Yes/i) }
              output.raw()[:facets_toplevel] << "peer_reviewed"
            end
          end
          if output.raw()[:delivery_delcategory] == "Online Resource"
            output.raw()[:facets_toplevel] << "online_resources"
          end
          if output.raw()[:delivery_delcategory] == "Online Resource" && output.raw()[:delivery_resdelscope].nil?
            output.raw()[:facets_toplevel] << "open_access"
            output.raw()[:oa] = "free_for_read"
          end
          # pp   output.raw()[:facets_toplevel]

          log("-- facets_prefilter  --") if debugging
          output.raw()[:facets_prefilter] = Format_mean[ output.raw()[:type] ]
          log("-- facets_rsrctype  --") if debugging
          output.raw()[:facets_rsrctype]  = output.raw()[:facets_prefilter]

          resolver_data_lirias_records = output.raw().slice(:id, :wosid, :scopus, :pmid, :doi, :isbn_13, :isbn10, :issn, :eissn, :additional_identifier, :files, :public_url, :author, :editor, :supervisor, :co_supervisor, :contributor)
          resolver_data[ resolver_data_lirias_records[:id] ] = resolver_data_lirias_records
          counter += 1
        end

        if  output[:deleted]
          dcounter += 1
        else
          #last_affected_when = output[:updated][0]

          #puts "records_dir: #{records_dir}"
          print "."
          #create JSON files for resolver
          output.to_jsonfile(output.raw(), "primoVE_#{output.raw()[:id]}",records_dir)
          resolver_data_lirias_records = output.raw().slice(:id, :wosid, :scopus, :pmid, :doi, :isbn_13, :isbn10, :issn, :eissn, :additional_identifier, :files, :public_url, :author, :editor, :supervisor, :co_supervisor, :contributor)
          resolver_data[ resolver_data_lirias_records[:id] ] = resolver_data_lirias_records
          counter += 1
        end

        #log("INFO id : #{    output[:id] }")

        output.clear()

      end

      updated_records = counter
      not_claimed_records = dcounter

      log(" last_affected_when #{ last_affected_when } ")
      log(" records created #{ updated_records } ")
      log(" delete-records (not claimed) #{ dcounter } ")

      
      
      if tar_records
        filename      = "lirias_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{records_dir}"
        PrimoVE_create_tar(full_filename, directory_to_process)
      end

=begin
      if one_xml_file
        filename      = "lirias_#{Time.now.to_i}.xml"
        full_filename =  "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_records_dir}/*.xml"

        create_large_xml(full_filename, directory_to_process)
      end

      if tar_records
        filename      = "lirias_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_records_dir}"

        create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_records_dir)
      end
=end
      #create JSON files for resolver
      output.to_jsonfile(resolver_data, "lirias_resolver_data",records_dir)
      # output.to_jsonfile(resolver_authors, "lirias_resolver_author")

=begin      
      if one_xml_file
        filename      = "lirias_not_claimed_#{Time.now.to_i}.xml"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process = "#{tmp_not_claimed_records_dir}/*.xml"
        create_large_xml(full_filename, directory_to_process)
      end

      if tar_records
        filename      = "lirias_not_claimed_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_not_claimed_records_dir}"
        create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_not_claimed_records_dir)
      end
=end
      #create JSON files for resolver
      if !resolver_data_not_claimed_lirias_records.empty?
        output.to_jsonfile(resolver_data_not_claimed_lirias_records, "lirias_resolver_deleted_data",records_dir)
      end

      #update config with the new data
      log(" update  config[:last_run_updates] with #{ last_affected_when } ")
      config[:last_run_updates] = last_affected_when

      #Filter next URL
      url = filter(data, '$..link[?(@._rel=="next")]._href').first || nil
      log("Converted in #{((Time.now - timing_start) * 1000).to_i} ms")

      if counter > max_updated_records
        url = nil
      end
    end


    log("Get Deleted affected-since #{from_date_deleted} ")

    #url_delete = "https://lirias2test.libis.kuleuven.be/elements-cache/rest/deleted/publications?per-page=1000&deleted-since=2018-04-24T13%3A14%3A06%2B00%3A00"

    log("Load URL (delete) #{url_delete}")

    dcounter = 0
    while url_delete
      timing_start = Time.now
      #Load data
      data = input.from_uri(url_delete, url_options)
      tmp_records_dir = "#{records_dir}/records_delete_#{Time.now.to_i}"

      resolver_deleted_data = {}

      log("Data loaded in #{((Time.now - timing_start) * 1000).to_i} ms")

      resolver_data_lirias_records = []

      timing_start = Time.now
      #Filter on Object
      filter(data, '$..entry[*].deleted_object').each do |object|
        output[:id] = filter(object, '@._id').first
        output[:deleted] = filter(object, '@._deleted_when')

        #log(" record id #{ output[:id] } deleted")
        output.to_jsonfile(output.raw(), "primoVE_#{output.raw()[:id]}",records_dir)
=begin        
        #output.to_tmp_file("templates/lirias_delete_template.erb",tmp_records_dir)
        output.to_tmp_file(delete_template,tmp_records_dir)
=end
        deleted_when = output[:deleted][0]
        resolver_data_lirias_records << output.raw()

        #results are sorted by deleted_when
        dcounter += 1
        output.clear()
      end

      deleted_records = dcounter
      #log(" deleted_when #{ deleted_when } ")
      log(" delete-records created #{ deleted_records } ")


      if tar_records
        filename      = "lirias_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{records_dir}"
        PrimoVE_create_tar(full_filename, directory_to_process)
      end


=begin
      if one_xml_file
        filename      = "lirias_deleted_#{Time.now.to_i}.xml"
        full_filename =  "#{records_dir}/#{filename}"
        directory_to_process = "#{tmp_records_dir}/*.xml"
        create_large_xml(full_filename, directory_to_process)
      end

      if tar_records
          filename      = "lirias_deleted_#{Time.now.to_i}.tar.gz"
          full_filename = "#{records_dir}/#{filename}"
          directory_to_process  = "#{tmp_records_dir}"
          create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_records_dir)
      end
=end
      if !resolver_data_lirias_records.empty?
        output.to_jsonfile(resolver_data_lirias_records, "lirias_resolver_deleted_data",records_dir)
      end

      #update config with the new data
      log("update config[:last_run_delete] with #{ last_affected_when } ")
      config[:last_run_deletes] = deleted_when

      url_delete = filter(data, '$..link[?(@._rel=="next")]._href').first || nil

      if dcounter > max_deleted_records || debugging
        url_delete = nil
      end
    end

  ensure
    log("Counted #{updated_records} updated records")
    log("Counted #{not_claimed_records} deleted records (not claimed)")
    log("Counted #{deleted_records} deleted records")
    # config[:last_run_updates] = Time.now.xmlschema
  end
end
