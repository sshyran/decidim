import attachGeocoding from '../../../../../../../../decidim-core/app/packs/src/decidim/geocoding/attach_input'

$(() => {
  const $form = $(".edit_polling_station, .new_polling_station");
  attachGeocoding($form.find("#polling_station_address"));
})
