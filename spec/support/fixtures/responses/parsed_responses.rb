module Fixtures
  class ParsedResponses
    class << self
      def create_shipment
        {"Envelope"=>
          {"xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
           "xmlns:SOAP_ENV"=>"http://schemas.xmlsoap.org/soap/envelope/",
           "Body"=>
            {"createShipmentResponse"=>
              {"xmlns"=>"http://www.royalmailgroup.com/api/ship/V2",
               "integrationHeader"=>
                {"dateTime"=>"2015-02-09T08:52:03",
                 "version"=>"2",
                 "identification"=>{"xmlns"=>"http://www.royalmailgroup.com/integration/core/V1", "applicationId"=>"111111113", "transactionId"=>"730222611"}},
               "completedShipmentInfo"=>
                {"status"=>{"status"=>{"xmlns"=>"", "statusCode"=>{"code"=>"Allocated"}}, "validFrom"=>"2015-02-09T09:52:06.000+02:00"},
                 "allCompletedShipments"=>
                  {"completedShipments"=>
                    {"weight"=>{"unitOfMeasure"=>{"xmlns"=>"", "unitOfMeasureCode"=>{"code"=>"g"}}, "value"=>"100"},
                     "shipments"=>
                      {"shipmentNumber"=>["ZTL", "HY188980166GB"],
                       "shipment"=>
                        [{"shipmentNumber"=>"HY188980152GB",
                          "itemID"=>"1000076",
                          "status"=>{"status"=>{"xmlns"=>"", "statusCode"=>{"code"=>"Allocated"}}, "validFrom"=>"2015-02-09T09:52:06.000+02:00"}},
                         {"shipmentNumber"=>"HY188980166GB",
                          "itemID"=>"1000077",
                          "status"=>{"status"=>{"xmlns"=>"", "statusCode"=>{"code"=>"Allocated"}}, "validFrom"=>"2015-02-09T09:52:06.000+02:00"}}]}}},
                 "requestedShipment"=>
                  {"shipmentType"=>{"code"=>"Delivery"},
                   "serviceOccurrence"=>"1",
                   "serviceType"=>{"code"=>"T"},
                   "serviceOffering"=>{"serviceOfferingCode"=>{"xmlns"=>"", "code"=>"TRM"}},
                   "serviceFormat"=>{"serviceFormatCode"=>{"xmlns"=>""}},
                   "serviceEnhancements"=>{"enhancementType"=>{"serviceEnhancementCode"=>{"xmlns"=>""}}},
                   "s§hippingDate"=>"2015-02-09",
                   "recipientContact"=>
                    {"name"=>"Mr Tom Smith",
                     "complementaryName"=>"Department 98",
                     "telephoneNumber"=>{"countryCode"=>"0044", "telephoneNumber"=>"07801123456"},
                     "electronicAddress"=>{"electronicAddress"=>"tom.smith@royalmail.com"}},
                   "recipientAddress"=>{"addressLine1"=>"44-46 Morningside Road", "postTown"=>"Edinburgh", "postcode"=>"EH10 4BF", "country"=>{"xmlns"=>"", "countryCode"=>{"code"=>"GB"}}},
                   "items"=>{"item"=>{"numberOfItems"=>"2", "weight"=>{"unitOfMeasure"=>{"xmlns"=>"", "unitOfMeasureCode"=>{"code"=>"g"}}, "value"=>"100"}}},
                   "customerReference"=>"CustSuppRef1",
                   "senderReference"=>"SenderReference1"}},
               "integrationFooter"=>
                {"warnings"=>
                  {"xmlns"=>"http://www.royalmailgroup.com/integration/core/V1",
                   "warning"=>
                    [{"warningCode"=>"W0042", "warningDescription"=>"Missing data - the Service Format is required has been omitted so a default value has been used"},
                     {"warningCode"=>"W0036", "warningDescription"=>"E-mail option not selected so e-mail address will be ignored"},
                     {"warningCode"=>"W0035", "warningDescription"=>"SMS option not selected so Telephone Number will be ignored"}]}}}}}}
      end
    end
  end
end
