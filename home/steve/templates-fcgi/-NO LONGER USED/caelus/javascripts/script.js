$(function(){
    var now = new Date();
    // comment out the line below and change the date of your countdown here
    //var in30Days = new Date( now.getTime() + (30 * 24 * 60 * 60 * 1000) );
    // year to countdown to
    var countdownYear = 2013;
    // month to countdown to 0 = Jan, 1 = Feb, etc
    var countdownMonth = 7;
    // day to countdown to
    var countdownDay = 19;

    var countdownDate = new Date( countdownYear, countdownMonth, countdownDay );

    setupCountdownTimer( countdownDate );

    spaceParallax();

    hideIphoneBar();

    $("[placeholder]").togglePlaceholder();

    setupSignupForm();
});


$(window).load(function() {
    slabTextHeadlines();
});


// Function to slabtext the hero panel
function slabTextHeadlines() {
    $('html:not(.ie8)').find('.slab').slabText({
        // Don't slabtext the headers if the viewport is under 380px
        "viewportBreakpoint":380
    });
};

// countdown timer function
function setupCountdownTimer( date ) {
    var countdownUnit = $('.countdown-unit');
    var countdownBoxes = $(countdownUnit.find('span'));

    $('.countdown-unit').countdown({
        timestamp: date,
        callback: function(days, hours, minutes, seconds, ms){
            $(countdownBoxes[0]).html( days );
            $(countdownBoxes[1]).html( hours );
            $(countdownBoxes[2]).html( minutes );
            $(countdownBoxes[3]).html( seconds );
        }
    });
}

// Function to create subtle parallax space effect
function spaceParallax() {
    $('body').parallax({
        'elements': [
            {
              'selector': '.bg-1',
              'properties': {
                'x': {
                  'background-position-x': {
                    'initial': 0,
                    'multiplier': 0.02,
                    'invert': true
                  }
                }
              }
            },
            {
              'selector': '.bg-2',
              'properties': {
                'x': {
                  'background-position-x': {
                    'initial': 0,
                    'multiplier': 0.06,
                    'invert': true
                  }
                }
              }
            },
            {
              'selector': '.bg-3',
              'properties': {
                'x': {
                  'background-position-x': {
                    'initial': 0,
                    'multiplier': 0.2,
                    'invert': true
                  }
                }
              }
            }
        ]
    });
}

// Function to hide the address bar ion Iphone devices
function hideIphoneBar() {
    if( !window.location.hash && window.addEventListener ){
        window.addEventListener( "load",function() {
            setTimeout(function(){
                window.scrollTo(0, 0);
            }, 0);
        });
    }
}

$.fn.togglePlaceholder = function() {
    return this.each(function() {
        $(this)
        .data("holder", $(this).attr("placeholder"))
        .focusin(function(){
            $(this).attr('placeholder','');
        })
        .focusout(function(){
            $(this).attr('placeholder',$(this).data('holder'));
        });
    });
};

function setupSignupForm() {
    var mainDiv = $('.signup');
    $('.signup-button').click( function() {
        var email = $('#email-signup').val();
        // validate email here
        var request = $.ajax({
            url: "sign_me_up.php",
            context: this,
            type: "POST",
            dataType: "JSON",
            data: { "email": email }
        });

        request.done(function( data ) {
            if( data.error === undefined ) {
                mainDiv.find( '.response .email' ).text( data.email );
                mainDiv.find( '.response .status' ).text( 'Registered' );
                mainDiv.addClass( 'signup-active signup-success' );
            }
            else {
                mainDiv.find( '.response .email' ).text( data.email );
                mainDiv.find( '.response .status' ).text( data.error );
                mainDiv.addClass( 'signup-active signup-error' );
                setTimeout( function() {
                    mainDiv.removeClass( 'signup-active signup-error' )
                }, 3000 );
            }
        });

        return false;
    });

    // fix placeholders for ie8, ie9
    $('.ie8, .ie9').find('input').placeholder();
}
;
