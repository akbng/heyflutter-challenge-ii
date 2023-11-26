import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/file_utils.dart';
import 'package:weather_app/models/google/location.dart';

void main() {
  test('Shoud parse JSON returned from API correctly', () async {
    final sampleData = await readJsonFile('test/mock_data/place_details.json');
    final location = GoogleLocation.fromJson(sampleData);

    expect(location.placeId, "ChIJN1t_tDeuEmsRUsoyG83frY4");
    expect(location.country, "Australia");
    expect(location.city, "Pyrmont");
    expect(location.latitude, -33.866489);
    expect(location.longitude, 151.1958561);
  });

  test("Should prefer vertical photo references", () async {
    final sampleData = await readJsonFile('test/mock_data/place_details.json');
    final location = GoogleLocation.fromJson(sampleData);

    expect(
      location.photoReference,
      "Aap_uECQynuD_EnSnbz8sJQ6-B6uR-j2tuu4Z1tuGUjq8xnxFDk-W8OdeLzWBX8suNKTCsPlkzTqC22BXf_hX33XclGPL4SS9xnPmHcMrLoUl0H_xHYevFvT17Hgw5DZpSyVmLvDvxzzJ1rsZTh55QwopmAty083a1r1ZIfL32iXh_q8FUas",
    );
  });
}
