data = {
                    "recordid": "lirias2374734",
                    "oa": "free_for_read",
                    "open_access_status": "Gold OA",
                    "issn": "2072-6694",
                    "facets_toplevel": [
                      "open_access",
                        "online_resources",
                        "peer_reviewed"
                    ],
                    "identifiers": [
                        "$$CISSN:$$V2072-6694",
                        "$$CEISSN:$$V2072-6694",
                        "$$CDOI:$$V10.3390/cancers11020235",
                        "$$Cexternal_identifiers:$$VPMC6406377",
                        "$$CPMID:$$V30781655",
                        "$$CSCOPUSID:$$V2-s2.0-85063581558"
                    ],
                    "is_open_access": "true",
                    "linktorsrc": "$$Uhttp://doi.org/10.3390/cancers11020235$$D10.3390/cancers11020235$$Hfree_for_read",
                    "delivery_delcategory": "fulltext_linktorsrc",
                    "doi": "10.3390/cancers11020235"
                }

                filtered_linktorsrc = data[:linktorsrc].is_a?(String) ? [ data[:linktorsrc] ] : data[:linktorsrc]

                filtered_linktorsrc.select!{ |l| ! /\$\$DSupporting information/i.match(l) }
                filtered_linktorsrc.select!{ |l| ! /\$\$Uhttp(s*):\/\/doi.org\//i.match(l)  || data[:facets_toplevel].include?("open_access") }

                pp filtered_linktorsrc


