module AddressMappingHelper
    # Map zone to corresponding address
    def building_name_list
        [
          "USF Banyan Circle",
          "Moffitt Cancer Center",
          "USF Hawthorn Dr",
          "USF Pine Drive",
          "Bruce B Downs Blvd",
          "USF Magnolia Drive",
          "USF Alumni Drive",
          "USF Laurel Dr",
          "USF Holly Drive MUS",
          "USF Beard Drive",
          "Spectrum Blvd",
          "USF Mulberry Lane",
          "Cedar Circle",
          "Leroy Collins Blvd",
          "USF Apple Dr",
          "USF Dogwood Dr",
          "USF Willow Dr",
          "USF Holly Drive",
          "E Fowler Ave",
          "USF Sago Drive",
          "USF Birch Dr",
          "USF Genshaft Dr",
          "USF Bull Run Dr",
          "N 50th St",
          "USF Bull Run Drive"
          # etc — list all your real building names here
        ]
    end
    def zone_to_address(zone)
      addresses = {
        "A_1" => "3010 USF Banyan Circle Tampa, FL 33612",
        "A_2" => "12901 Bruce B. Downs Blvd, Tampa, FL",
        "A_3" => "12908 USF Hawthorn Dr, Tampa, FL 33612",
        "A_4" => "12210 USF Pine Drive, Tampa, FL 33612",
        "B_1" => "13301 Bruce B Downs Blvd, Tampa, FL 33612",
        "B_2" => "12902 USF Magnolia Drive, Tampa, FL 33612",
        "B_3" => "14200 USF Magnolia Drive, Tampa, FL 33612",
        "B_4" => "3602 Spectrum Blvd, Tampa, FL 33612",
        "B_5" => "3301 USF Alumni Drive, Tampa, FL 33612",
        "C_1" => "13325 USF Laurel Dr, Tampa, FL 33620",
        "C_2" => "3755 USF Holly Drive MUS 101, Tampa, FL 33620",
        "C_3" => "12037 USF Beard Drive, Tampa, FL 33620",
        "C_4" => "12033 USF Beard Drive, Tampa FL 33620",
        "C_5" => "3720 Spectrum Blvd, Tampa, FL 33612",
        "D_1" => "4204 USF Mulberry Lane Tampa, FL 33620",
        "D_2" => "4103 Cedar Circle Tampa, FL 33620",
        "D_3" => "12100 Leroy Collins Blvd. Tampa, FL 33620",
        "D_4" => "4101 USF Apple Dr, Tampa, FL 33620",
        "D_5" => "3814 Spectrum Blvd, Tampa, FL 33612",
        "E_1" => "4303 USF Dogwood Dr, Tampa, FL 33620",
        "E_2" => "4302 USF Holly Drive Tampa, FL 33620",
        "E_3" => "4205 USF Willow Dr, Tampa, FL 33620",
        "E_4" => "4202 E Fowler Ave, Tampa, Florida 33620",
        "E_5" => "11810 USF Sago Drive Tampa, FL 33620",
        "F_1" => "4747 USF Birch Dr, Tampa, FL 33620",
        "F_3" => "12301 USF Genshaft Dr, Tampa, FL 33620",
        "F_4" => "12560 USF Bull Run Dr. Tampa, FL 33620",
        "F_5" => "11801 USF Bull Run Drive, Tampa, FL 33620",
        "G_2" => "13110 N 50th St, Tampa, FL 33620",
        "G_3" => "12850 N 50th St. Tampa, FL 33617",
        "G_4" => "11811 USF Bull Run Drive, Tampa, FL 33620",
        "G_5" => "11701 USF Bull Run Drive, Tampa, FL 33620"
      }
      addresses[zone] || "Address not found"
    end
  end