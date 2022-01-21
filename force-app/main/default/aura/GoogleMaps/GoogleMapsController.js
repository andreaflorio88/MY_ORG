({
    init: function (cmp, event, helper) {
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: '40 Via Crati',
                    City: 'Rende',
                    State: 'IT'
                },

                title: 'Florio House',
                description: ''
            },
            {
            location: {
                    Street: 'Via Kennedy',
                    City: 'Rende',
                    State: 'IT'
                },

                title: 'Metropolis',
                description: ''
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    }
})