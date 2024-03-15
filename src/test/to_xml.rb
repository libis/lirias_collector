
#encoding: UTF-8
require 'active_support/core_ext/hash'
require 'active_support/core_ext/array'
# require 'jsonpath'
# require 'logger'


# require 'nokogiri'
# require 'pp'


puts (  {'foo' => 1, 'bar' => 2}.to_xml )
data = { :foo => 'bar', :foo1 => { :foo2 => 'bar2', :foo3 => 'bar3', :foo4 => [{ :foo5 => ['bar5a','bar5b','bar5c'] }, { :foo6 => ['bar6a','bar6b','bar6c'] },]}}
puts  data.class
puts data.to_xml(skip_instruct: true)


=begin
data = {"source":"lirias","sourceid":"lirias","id":"1645613","sourcerecordid":"1645613","lirias_type":"journal-article","updated":"2022-10-22T04:23:41.443+02:00","elements_creation_date":"2018-04-05T23:25:06.327+02:00","claimed":true,"facets_creator_contributor":["Maar, Marie","Butenschon, Momme","Daewel, Ute","Eggert, Anja","Fan, Wei","Hjollo, Solfrid S","Hufnagl, Marc","Huret, Martin","Ji, Rubao","Lacroix, Genevieve","U0084206","Peck, Myron A","Radtke, Hagen","Sailley, Sevrine","Sinerchia, Matteo","Skogen, Morten D","Travers-Trolet, Morgane","Troost, Tineke A","van de Wolfshaar, Karen"],"recordid":"lirias1645613","title":"Responses of summer phytoplankton biomass to changes in top-down forcing: Insights from comparative modelling"}
=end


data ={ "source"=>"lirias", "sourceid"=>"lirias", "id"=>"2143945", "sourcerecordid"=>"2143945", "lirias_type"=>"journal-article", "updated"=>"2023-01-30T18:51:20.147+01:00", 
    "elements_creation_date"=>"2018-09-17T14:40:35.977+02:00", "claimed"=>true, "facets_creator_contributor"=>["Krueger, S", "Mottaghy, FM", "U0054769", "Buck, AK", "Maschke, S", "Kley, H", "Frechen, D", "Wibmer, T", "Reske, SN", "Pauls, S"], 
    "identifiers"=>["$$CISSN:$$V0029-5566", "$$CEISSN:$$V2567-6407", "$$CDOI:$$V10.3413/Nukmed-0338-10-07", "$$Cexternal_identifiers:$$V21165538", "$$CPMID:$$V21165538"], 
    "recordid"=>"lirias2143945", "type"=>"article", "ristype"=>"JOUR", "facets_prefilter"=>"articles", "facets_rsrctype"=>"articles", 
    "title"=>"Brain metastasis in lung cancer Comparison of cerebral MRI and F-18-FDG-PET/CT for diagnosis in the initial staging", "volume"=>"50", "issue"=>"3", 
    "medium"=>"Print-Electronic", "pagination"=>{"begin_page"=>"101", "end_page"=>"106", "page_count"=>"6", "pagination"=>"101 - 106"},
     "number_of_pages"=>"6", "publisher"=>"Thieme Publishing", "doi"=>"10.3413/Nukmed-0338-10-07", "eissn"=>"2567-6407", "external_identifiers"=>"21165538", 
     "is_open_access"=>false, 
     "abstract"=>"UNLABELLED: FDG-PET/CT is increasingly used in staging of lung cancer as single \"one stop shop\" method. AIM, PATIENTS, METHODS: We prospectively included 104 neurological asymptomatic patients (65 years, 26% women) with primary diagnosis of lung cancer. In all patients PET/CT including cerebral imaging and cerebral MRI were performed. RESULTS: Diagnosis of brain metastases (BM) was made by PET/CT in 8 patients only (7.7%), by MRI in 22 (21.2%). In 80 patients both PET/CT and MRI showed no BM. In 6 patients (5.8%) BM were detectable on PET/CT as well as on MRI. Exclusive diagnosis of BM by MRI with negative finding on PET/CT was present in 16 patients (15.4%). 2 patients (1.9%) had findings typical for BM on PET/CT but were negative on MRI. With MRI overall 100 BM were detected, with PET/CT only 17 BM (p < / 0.01). For the diagnosis of BM PET/CT showed a sensitivity of 27.3%, specificity of 97.6%, positive predictive value of 75% and negative predictive value of 83.3%. BM diameter on PET/CT and MRI were consistent in 43%, in 57% BM were measured larger on MRI. DISCUSSION: Compared to the gold standard of MRI for cerebral staging a considerable number of patients are falsely diagnosed as free from BM by PET/CT. MRI is more accurate than PET/CT for detecting multiple and smaller BM. CONCLUSION: In patients with a curative option MRI should be performed additionally to PET/CT for definitive exclusion of brain metastases.", "author_url"=>"https://www.webofscience.com/api/gateway?GWVersion=2&SrcApp=PARTNER_APP&SrcAuth=LinksAMR&KeyUT=WOS:000291965600002&DestLinkType=FullRecord&DestApp=ALL_WOS&UsrCustomerID=ef845e08c439e550330acc77c7d2d848", "publication_status"=>"Published", "location"=>"Germany", "journal"=>"Nuklearmedizin-Nuclear Medicine", "issn"=>"0029-5566", 
     "pii"=>"#<Date: 0338-10-07 ((1844792j,0s,0n),+0s,2299161j)>", 
     "language"=>"eng", "peer_reviewed"=>"Yes - author can provide reports", 
     "public_url"=>"https://lirias.kuleuven.be/2143945", 
     "organizational_unit"=>["51841970", "50000050", "50000598", "50000677", "50000683"], "publication_date"=>"2011-01-01",
      "online_publication_date"=>"2010-12-17", "acceptance_date"=>"2010-11-25", "author"=>[{"identifiers"=>[{"researcherid"=>"DVG-0010-2022"}, {"dais"=>"15230413"},
         {"orcid"=>"0000-0001-8204-1110"}], "last_name"=>"Krueger", "first_names"=>"S", "initials"=>"S", "name"=>"Krueger, S", "pnx_display_name"=>"Krueger, S$$QKrueger, S", "display_name"=>"Krueger, S"}, {"identifiers"=>[{"staff_nbr"=>"U0054769"}, {"researcherid"=>"AAU-2673-2020"}, {"dais"=>"2040751"}, {"orcid"=>"0000-0002-7212-6521"}], "last_name"=>"Mottaghy", "first_names"=>"FM", "initials"=>"FM", "name"=>"Mottaghy, FM", "pnx_display_name"=>"Mottaghy, FM$$QMottaghy, FM", "display_name"=>"Mottaghy, FM"}, {"identifiers"=>[{"researcherid"=>"CRH-9938-2022"}, {"dais"=>"8070346"}, {"orcid"=>"0000-0002-5361-0895"}], "last_name"=>"Buck", "first_names"=>"AK", "initials"=>"AK", "name"=>"Buck, AK", "pnx_display_name"=>"Buck, AK$$QBuck, AK", "display_name"=>"Buck, AK"}, {"identifiers"=>[{"researcherid"=>"DFZ-6046-2022"}, {"dais"=>"11586453"}], "last_name"=>"Maschke", "first_names"=>"S", "initials"=>"S", "name"=>"Maschke, S", "pnx_display_name"=>"Maschke, S$$QMaschke, S", "display_name"=>"Maschke, S"}, {"identifiers"=>[{"researcherid"=>"CZS-4799-2022"}, {"dais"=>"10155206"}], "last_name"=>"Kley", "first_names"=>"H", "initials"=>"H", "name"=>"Kley, H", "pnx_display_name"=>"Kley, H$$QKley, H", "display_name"=>"Kley, H"}, {"identifiers"=>[{"researcherid"=>"EVD-5394-2022"}, {"dais"=>"21555787"}], "last_name"=>"Frechen", "first_names"=>"D", "initials"=>"D", "name"=>"Frechen, D", "pnx_display_name"=>"Frechen, D$$QFrechen, D", "display_name"=>"Frechen, D"}, {"identifiers"=>[{"researcherid"=>"EFW-5324-2022"}, {"dais"=>"17835726"}], "last_name"=>"Wibmer", "first_names"=>"T", "initials"=>"T", "name"=>"Wibmer, T", "pnx_display_name"=>"Wibmer, T$$QWibmer, T", "display_name"=>"Wibmer, T"}, {"identifiers"=>[{"researcherid"=>"DMN-8530-2022"}, {"dais"=>"13178933"}], "last_name"=>"Reske", "first_names"=>"SN", "initials"=>"SN", "name"=>"Reske, SN", "pnx_display_name"=>"Reske, SN$$QReske, SN", "display_name"=>"Reske, SN"}, {"identifiers"=>[{"researcherid"=>"DKR-4308-2022"}, {"dais"=>"12694712"}], "last_name"=>"Pauls", "first_names"=>"S", "initials"=>"S", "name"=>"Pauls, S", "pnx_display_name"=>"Pauls, S$$QPauls, S", "display_name"=>"Pauls, S"}], "first_author"=>{"identifiers"=>[{"researcherid"=>"DVG-0010-2022"}, {"dais"=>"15230413"}, {"orcid"=>"0000-0001-8204-1110"}], "last_name"=>"Krueger", "first_names"=>"S", "initials"=>"S", "name"=>"Krueger, S", "pnx_display_name"=>"Krueger, S$$QKrueger, S", "display_name"=>"Krueger, S"}, "contributor"=>[], "search_creationdate"=>"20110101", "risdate"=>"20110101", "search_startdate"=>"20110101", "search_enddate"=>"20111231", "journal_title"=>"Nuklearmedizin-Nuclear Medicine", "description"=>"UNLABELLED: FDG-PET/CT is increasingly used in staging of lung cancer as single \"one stop shop\" method. AIM, PATIENTS, METHODS: We prospectively included 104 neurological asymptomatic patients (65 years, 26% women) with primary diagnosis of lung cancer. In all patients PET/CT including cerebral imaging and cerebral MRI were performed. RESULTS: Diagnosis of brain metastases (BM) was made by PET/CT in 8 patients only (7.7%), by MRI in 22 (21.2%). In 80 patients both PET/CT and MRI showed no BM. In 6 patients (5.8%) BM were detectable on PET/CT as well as on MRI. Exclusive diagnosis of BM by MRI with negative finding on PET/CT was present in 16 patients (15.4%). 2 patients (1.9%) had findings typical for BM on PET/CT but were negative on MRI. With MRI overall 100 BM were detected, with PET/CT only 17 BM (p < / 0.01). For the diagnosis of BM PET/CT showed a sensitivity of 27.3%, specificity of 97.6%, positive predictive value of 75% and negative predictive value of 83.3%. BM diameter on PET/CT and MRI were consistent in 43%, in 57% BM were measured larger on MRI. DISCUSSION: Compared to the gold standard of MRI for cerebral staging a considerable number of patients are falsely diagnosed as free from BM by PET/CT. MRI is more accurate than PET/CT for detecting multiple and smaller BM. CONCLUSION: In patients with a curative option MRI should be performed additionally to PET/CT for definitive exclusion of brain metastases.", "local_field_08"=>"Published", "ispartof"=>"Nuklearmedizin-Nuclear Medicine; 2011; Vol. 50; iss. 3; pp. 101 - 106", "backlink"=>"$$Uhttps://lirias.kuleuven.be/2143945$$Ebacklink_lirias", "delivery_delcategory"=>"fulltext_linktorsrc", "linktorsrc"=>"$$Uhttp://doi.org/10.3413/Nukmed-0338-10-07$$D10.3413/Nukmed-0338-10-07$$Hfree_for_read", "delivery_fulltext"=>"fulltext_unknown", "facets_toplevel"=>"peer_reviewed", "keyword"=>["Science & Technology", "Life Sciences & Biomedicine", "Radiology, Nuclear Medicine & Medical Imaging", "PET/CT", "MRI", "brain metastasis", "lung cancer", "POSITRON-EMISSION-TOMOGRAPHY", "COMPUTED-TOMOGRAPHY", "FDG-PET", "CELL", "CARCINOMA", "ADENOCARCINOMA", "RADIOSURGERY", "GUIDELINE", "ACCURACY", "EFFICACY", "Adult", "Aged", "Aged, 80 and over", "Brain Neoplasms", "Carcinoma", "Female", "Fluorodeoxyglucose F18", "Germany", "Humans", "Lung Neoplasms", "Magnetic Resonance Imaging", "Male", "Middle Aged", "Neoplasm Staging", "Positron-Emission Tomography", "Prevalence", "Radiopharmaceuticals", "Reproducibility of Results", "Risk Assessment", "Risk Factors", "Sensitivity and Specificity", "Tomography, X-Ray Computed", "Humans", "Carcinoma", "Brain Neoplasms", "Lung Neoplasms", "Fluorodeoxyglucose F18", "Radiopharmaceuticals", "Positron-Emission Tomography", "Tomography, X-Ray Computed", "Magnetic Resonance Imaging", "Neoplasm Staging", "Prevalence", "Risk Assessment", "Risk Factors", "Sensitivity and Specificity", "Reproducibility of Results", "Adult", "Aged", "Aged, 80 and over", "Middle Aged", "Germany", "Female", "Male", "1103 Clinical Sciences", "Nuclear Medicine & Medical Imaging", "3202 Clinical sciences"], "pmid"=>"21165538", "wosid"=>"WOS:000291965600002", "subject"=>["Science & Technology", "Life Sciences & Biomedicine", "Radiology, Nuclear Medicine & Medical Imaging", "PET/CT", "MRI", "brain metastasis", "lung cancer", "POSITRON-EMISSION-TOMOGRAPHY", "COMPUTED-TOMOGRAPHY", "FDG-PET", "CELL", "CARCINOMA", "ADENOCARCINOMA", "RADIOSURGERY", "GUIDELINE", "ACCURACY", "EFFICACY", "Adult", "Aged", "Aged, 80 and over", "Brain Neoplasms", "Carcinoma", "Female", "Fluorodeoxyglucose F18", "Germany", "Humans", "Lung Neoplasms", "Magnetic Resonance Imaging", "Male", "Middle Aged", "Neoplasm Staging", "Positron-Emission Tomography", "Prevalence", "Radiopharmaceuticals", "Reproducibility of Results", "Risk Assessment", "Risk Factors", "Sensitivity and Specificity", "Tomography, X-Ray Computed", "1103 Clinical Sciences", "Nuclear Medicine & Medical Imaging", "3202 Clinical sciences"], "creator"=>[{"identifiers"=>[{"researcherid"=>"DVG-0010-2022"}, {"dais"=>"15230413"}, {"orcid"=>"0000-0001-8204-1110"}], "last_name"=>"Krueger", "first_names"=>"S", "initials"=>"S", "name"=>"Krueger, S", "pnx_display_name"=>"Krueger, S$$QKrueger, S", "display_name"=>"Krueger, S"}, {"identifiers"=>[{"staff_nbr"=>"U0054769"}, {"researcherid"=>"AAU-2673-2020"}, {"dais"=>"2040751"}, {"orcid"=>"0000-0002-7212-6521"}], "last_name"=>"Mottaghy", "first_names"=>"FM", "initials"=>"FM", "name"=>"Mottaghy, FM", "pnx_display_name"=>"Mottaghy, FM$$QMottaghy, FM", "display_name"=>"Mottaghy, FM"}, {"identifiers"=>[{"researcherid"=>"CRH-9938-2022"}, {"dais"=>"8070346"}, {"orcid"=>"0000-0002-5361-0895"}], "last_name"=>"Buck", "first_names"=>"AK", "initials"=>"AK", "name"=>"Buck, AK", "pnx_display_name"=>"Buck, AK$$QBuck, AK", "display_name"=>"Buck, AK"}, {"identifiers"=>[{"researcherid"=>"DFZ-6046-2022"}, {"dais"=>"11586453"}], "last_name"=>"Maschke", "first_names"=>"S", "initials"=>"S", "name"=>"Maschke, S", "pnx_display_name"=>"Maschke, S$$QMaschke, S", "display_name"=>"Maschke, S"}, {"identifiers"=>[{"researcherid"=>"CZS-4799-2022"}, {"dais"=>"10155206"}], "last_name"=>"Kley", "first_names"=>"H", "initials"=>"H", "name"=>"Kley, H", "pnx_display_name"=>"Kley, H$$QKley, H", "display_name"=>"Kley, H"}, {"identifiers"=>[{"researcherid"=>"EVD-5394-2022"}, {"dais"=>"21555787"}], "last_name"=>"Frechen", "first_names"=>"D", "initials"=>"D", "name"=>"Frechen, D", "pnx_display_name"=>"Frechen, D$$QFrechen, D", "display_name"=>"Frechen, D"}, {"identifiers"=>[{"researcherid"=>"EFW-5324-2022"}, {"dais"=>"17835726"}], "last_name"=>"Wibmer", "first_names"=>"T", "initials"=>"T", "name"=>"Wibmer, T", "pnx_display_name"=>"Wibmer, T$$QWibmer, T", "display_name"=>"Wibmer, T"}, {"identifiers"=>[{"researcherid"=>"DMN-8530-2022"}, {"dais"=>"13178933"}], "last_name"=>"Reske", "first_names"=>"SN", "initials"=>"SN", "name"=>"Reske, SN", "pnx_display_name"=>"Reske, SN$$QReske, SN", "display_name"=>"Reske, SN"}, {"identifiers"=>[{"researcherid"=>"DKR-4308-2022"}, {"dais"=>"12694712"}], "last_name"=>"Pauls", "first_names"=>"S", "initials"=>"S", "name"=>"Pauls, S", "pnx_display_name"=>"Pauls, S$$QPauls, S", "display_name"=>"Pauls, S"}], "format"=>"Print-Electronic page(s): 6", "facets_staffnr"=>"staffnr_U0054769", "local_field_07"=>"journal-article", "local_field_10"=>[], "local_facet_10"=>["51841970", "50000050", "50000598", "50000677", "50000683"], "article_title"=>"Brain metastasis in lung cancer Comparison of cerebral MRI and F-18-FDG-PET/CT for diagnosis in the initial staging"}




date = {"source"=>"lirias",
    "sourceid"=>"lirias",
    "id"=>"1657241",
    "sourcerecordid"=>"1657241",
    "lirias_type"=>"journal-article",
    "updated"=>"2023-01-05T05:30:22.36+01:00",
    "elements_creation_date"=>"2018-04-29T15:44:51.61+02:00",
    "claimed"=>true,
    "facets_creator_contributor"=>
     ["Laurent, Michaël",
      "Claessens, Frank",
      "U0015200",
      "Joniau, Steven",
      "U0058487",
      "Van Poppel, Hendrik",
      "U0015731"],
    "identifiers"=>"$$CISSN:$$V1378-9767",
    "recordid"=>"lirias1657241",
    "type"=>"article",
    "ristype"=>"JOUR",
    "facets_prefilter"=>"articles",
    "facets_rsrctype"=>"articles",
    "title"=>
     "Radicale prostatectomie versus een afwachtend beleid bij gelokaliseerde door PSA-screening gedetecteerde prostaatkanker",
    "additional_identifier"=>"http://www.minerva-ebm.be/nl/review.asp?id=322",
    "publication_status"=>"Published",
    "article_number"=>#<Date: 2013-04-28 ((2456411j,0s,0n),+0s,2299161j)>,
    "journal"=>"Minerva: Tijdschrift voor Evidence-based Medicine",
    "issn"=>"1378-9767",
    "language"=>"eng",
    "peer_reviewed"=>["No", "No"],
    "vabb_type"=>"VABB-1",
    "vabb_identifier"=>"c:vabb:346745",
    "historic_collection"=>
     ["Gerontology and Geriatrics ;50000630",
      "Laboratory of Molecular Endocrinology;50753346",
      "Organ Systems (+);52445377"],
    "public_url"=>
     ["https://lirias.kuleuven.be/handle/123456789/400723",
      "https://lirias.kuleuven.be/1657241"],
    "professional_oriented"=>"false",
    "organizational_unit"=>
     ["51841970",
      "50000050",
      "50000598",
      "50000600",
      "50000640",
      "54964600",
      "50000625",
      "50000630",
      "50000618",
      "50753346"],
    "publication_date"=>"2013-04-28",
    "author"=>
     [{"identifiers"=>
        [{"orcid"=>"0000-0001-9681-8330"}, {"researcherid"=>"D-5748-2011"}],
       "last_name"=>"Laurent",
       "first_names"=>"Michaël",
       "initials"=>"M",
       "name"=>"Laurent, Michaël",
       "pnx_display_name"=>"Laurent, Michaël$$QLaurent, Michaël",
       "display_name"=>"Laurent, Michaël"},
      {"identifiers"=>
        [{"orcid"=>"0000-0002-8676-7709"},
         {"researcherid"=>"M-8565-2016"},
         {"staff_nbr"=>"U0015200"}],
       "last_name"=>"Claessens",
       "first_names"=>"Frank",
       "initials"=>"F",
       "name"=>"Claessens, Frank",
       "pnx_display_name"=>"Claessens, Frank$$QClaessens, Frank",
       "display_name"=>"Claessens, Frank"},
      {"identifiers"=>
        [{"orcid"=>"0000-0003-3195-9890"},
         {"researcherid"=>"K-7655-2013"},
         {"staff_nbr"=>"U0058487"}],
       "last_name"=>"Joniau",
       "first_names"=>"Steven",
       "initials"=>"S",
       "name"=>"Joniau, Steven",
       "pnx_display_name"=>"Joniau, Steven$$QJoniau, Steven",
       "display_name"=>"Joniau, Steven"},
      {"identifiers"=>
        [{"orcid"=>"0000-0002-7458-8578"},
         {"researcherid"=>"CEB-5993-2022"},
         {"staff_nbr"=>"U0015731"}],
       "last_name"=>"Van Poppel",
       "first_names"=>"Hendrik",
       "initials"=>"H",
       "name"=>"Van Poppel, Hendrik",
       "pnx_display_name"=>"Van Poppel, Hendrik$$QVan Poppel, Hendrik",
       "display_name"=>"Van Poppel, Hendrik"}],
    "first_author"=>
     {"identifiers"=>
       [{"orcid"=>"0000-0001-9681-8330"}, {"researcherid"=>"D-5748-2011"}],
      "last_name"=>"Laurent",
      "first_names"=>"Michaël",
      "initials"=>"M",
      "name"=>"Laurent, Michaël",
      "pnx_display_name"=>"Laurent, Michaël$$QLaurent, Michaël",
      "display_name"=>"Laurent, Michaël"},
    "contributor"=>[],
    "search_creationdate"=>"20130428",
    "risdate"=>"20130428",
    "search_startdate"=>"20130101",
    "search_enddate"=>"20131231",
    "journal_title"=>"Minerva: Tijdschrift voor Evidence-based Medicine",
    "local_field_08"=>"Published",
    "ispartof"=>"Minerva: Tijdschrift voor Evidence-based Medicine; 2013",
    "backlink"=>
     ["$$Uhttps://lirias.kuleuven.be/handle/123456789/400723$$Ebacklink_lirias",
      "$$Uhttps://lirias.kuleuven.be/1657241$$Ebacklink_lirias"],
    "delivery_delcategory"=>"Remote Search Resource",
    "linktorsrc"=>
     "$$Uhttp://www.minerva-ebm.be/nl/review.asp?id=322$$Hfree_for_read",
    "delivery_fulltext"=>"fulltext_unknown",
    "creator"=>
     [{"identifiers"=>
        [{"orcid"=>"0000-0001-9681-8330"}, {"researcherid"=>"D-5748-2011"}],
       "last_name"=>"Laurent",
       "first_names"=>"Michaël",
       "initials"=>"M",
       "name"=>"Laurent, Michaël",
       "pnx_display_name"=>"Laurent, Michaël$$QLaurent, Michaël",
       "display_name"=>"Laurent, Michaël"},
      {"identifiers"=>
        [{"orcid"=>"0000-0002-8676-7709"},
         {"researcherid"=>"M-8565-2016"},
         {"staff_nbr"=>"U0015200"}],
       "last_name"=>"Claessens",
       "first_names"=>"Frank",
       "initials"=>"F",
       "name"=>"Claessens, Frank",
       "pnx_display_name"=>"Claessens, Frank$$QClaessens, Frank",
       "display_name"=>"Claessens, Frank"},
      {"identifiers"=>
        [{"orcid"=>"0000-0003-3195-9890"},
         {"researcherid"=>"K-7655-2013"},
         {"staff_nbr"=>"U0058487"}],
       "last_name"=>"Joniau",
       "first_names"=>"Steven",
       "initials"=>"S",
       "name"=>"Joniau, Steven",
       "pnx_display_name"=>"Joniau, Steven$$QJoniau, Steven",
       "display_name"=>"Joniau, Steven"},
      {"identifiers"=>
        [{"orcid"=>"0000-0002-7458-8578"},
         {"researcherid"=>"CEB-5993-2022"},
         {"staff_nbr"=>"U0015731"}],
       "last_name"=>"Van Poppel",
       "first_names"=>"Hendrik",
       "initials"=>"H",
       "name"=>"Van Poppel, Hendrik",
       "pnx_display_name"=>"Van Poppel, Hendrik$$QVan Poppel, Hendrik",
       "display_name"=>"Van Poppel, Hendrik"}],
    "facets_staffnr"=>
     ["staffnr_U0015200", "staffnr_U0058487", "staffnr_U0015731"],
    "local_field_07"=>"journal-article",
    "local_field_10"=>[],
    "local_facet_10"=>
     ["51841970",
      "50000050",
      "50000598",
      "50000600",
      "50000640",
      "54964600",
      "50000625",
      "50000630",
      "50000618",
      "50753346"],
    "article_title"=>
     "Radicale prostatectomie versus een afwachtend beleid bij gelokaliseerde door PSA-screening gedetecteerde prostaatkanker"}




puts  data.class
puts data.to_xml(root: "record")




exit