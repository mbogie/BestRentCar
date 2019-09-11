({
    doInit: function (component, event, helper) {
       /* let scroller = component.find('scroll_wrapper');
        let images = [];
        let getImages = component.get('c.getAllImages');
        getImages.setParams({});
        getImages.setCallback(this, response => {
            if (response.getState() === "SUCCESS") {
                images = response.getReturnValue();
                images.push('https://cdn.arstechnica.net/wp-content/uploads/2016/02/5718897981_10faa45ac3_b-640x624.jpg');

                component.set('v.totalWidth', images.length * 55);
                component.set('v.images', images);
            }
        });
        $A.enqueueAction(getImages);*/
        // scroller.scrollTo('right');
    },
    goLeft: function (component, event, helper) {
        // let scroller = component.find('scroll_wrapper');
        // scroller.scrollTo('left');
        let position = component.get('v.position');
        let y = 0;
        if (position > 94) {
            y = 95;
        } else {
            y = position;
        }
        let x = 1;
        let timeoutHandler = function (i) {
            if (i < y) {
                component.set('v.position', position - i);
                i += 3;
                setTimeout(() => {
                        timeoutHandler(i);
                    }
                    , 15);
            }
        };
        setTimeout(() => {
                timeoutHandler(x);
            }, 15
        );
        // component.set('v.position', position - 15);

        console.log('osiiton :' + position);
    },
    goRight: function (component, event, helper) {

        // let scroller = component.find('scroll_wrapper');
        // scroller.scrollTo('right');
        // if(position>10){
        //     component.set('v.position',position-10);
        // }

        let position = component.get('v.position');
        let y = 0;
        if (position + 95 < component.get('v.maxPosition')) {
            // component.set('v.position', position + 45);
            y = 95;
            console.log('osiiton :' + position);
        } else {
            // component.set('v.position', component.get('v.maxPosition'));
            y = component.get('v.maxPosition') - position;
            console.log('osiiton :' + position);
        }
        let x = 1;
        let timeoutHandler = function (i) {
            if (i < y) {
                component.set('v.position', position + i);
                i += 3;
                setTimeout(() => {
                        timeoutHandler(i);
                    }
                    , 15);
            }
        };
        setTimeout(() => {
                timeoutHandler(x);
            }, 15
        );
    },
    handleResize: function (component, event, helper) {
        // console.log("c : " + component.getElements());
        console.log('div scrollWidth : ' + component.find('inner').getElement().scrollWidth);
        let max = component.find('inner').getElement().scrollWidth;
        let shown = component.find('inner').getElement().offsetWidth;
        console.log('div offsetWidth : ' + component.find('inner').getElement().offsetWidth);
        if ((max - shown) === 0) {
            component.set('v.maxPosition', 1);
        } else {

            component.set('v.maxPosition', max - shown);
        }
        console.log('v.maxPosition' + component.get('v.maxPosition'));
        // console.log('after renfder :'+component.getConcreteComponent().getElementwidth);
    }
})
