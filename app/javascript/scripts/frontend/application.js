import bulmaCarousel from 'bulma-carousel';

document.addEventListener('turbolinks:load',()=>{
  let element = document.querySelector('#carousel-demo');

  if (element){
    bulmaCarousel.attach('#carousel-demo', {
      slidesToScroll: 1,
      slidesToShow: 4,
      infinite: true
    });
  }
});
