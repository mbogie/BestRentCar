({
    afterRender: function (component, helper) {
        this.superAfterRender();
        // interact with the DOM here
        console.log('after render');
        let position = component.get('v.position');
        let scroller = component.find('scroll_wrapper');
        // console.log('width : '+component.find('inner').getElements().getBoundingClientRect().width);
        // console.log(document.getElementById('myDiv').width);
        // let elements = document.getElementsByClassName('img_element');
        // elements.forEach(x => {
        //     console.log(x.style.width);
        // })
        let max = 0;
        // for (let i = 0; i < elements.length; i++) {
        //     max += elements[i].width;
        // }
        // // component.set('v.maxPosition', max);
        // console.log('width : ' + elements[0].width);
        scroller.scrollTo('custom', position, 0);
        console.log('osiiton :' + position);
    },
    render: function (component, helper) {
        // scroller.scrollTo('custom', position, 0);
        console.log('rendered');
        return this.superRender()
    }
    ,
    rerender: function (component, helper) {
        this.superRerender();
        console.log('rerendered');
        let position = component.get('v.position');
        let scroller = component.find('scroll_wrapper');
        scroller.scrollTo('custom', position, 0);
        console.log('osiiton :' + position);
    }
})
