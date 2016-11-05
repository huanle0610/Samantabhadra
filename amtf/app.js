angular.module('myApp', [
    "ngSanitize",
    "com.2fdevs.videogular",
    "com.2fdevs.videogular.plugins.controls",
    "com.2fdevs.videogular.plugins.overlayplay",
    "com.2fdevs.videogular.plugins.poster",
    "com.2fdevs.videogular.plugins.buffering"
]).factory('myService',
    function ($http) {
        return {
            getSoundSet: function () {
                //return the promise directly.
                return $http.get('data.json').then(function (result) {
                    //resolve the promise as the data
                    return result;
                });
            }
        }
    })
    .factory('highlighter', function () {
        return new Scrollbars.Highlighter();
    });

'use strict';
angular.module('myApp').controller('HomeCtrl', ["$sce", "$timeout", 'myService',
    function ($sce, $timeout, myService) {
        var controller = this;
        controller.state = null;
        controller.API = null;
        controller.currentVideo = 0;

        controller.onPlayerReady = function (API) {
            controller.API = API;
        };

        controller.onCompleteVideo = function () {
            controller.isCompleted = true;

            controller.currentVideo++;

            if (controller.currentVideo >= controller.videos.length) controller.currentVideo = 0;

            controller.setVideo(controller.currentVideo);
        };

        myService.getSoundSet().then(function (res) {
            controller.videos = res.data.items;
            //console.log(controller.videos, 456);
            controller.config = {
                preload: "none",
                autoHide: false,
                autoHideTime: 3000,
                autoPlay: false,
                sources: controller.videos[0].sound_url,
                theme: {
                    url: "http://www.videogular.com/styles/themes/default/latest/videogular.css"
                },
                tracks: [
                    {
                        src: $sce.trustAsResourceUrl("developerStories-subtitles-en.vtt"),
                        kind: "subtitles",
                        srclang: "en",
                        label: "English",
                        default: "true"
                    }
                ],
                plugins: {
                    poster: "http://www.fomen123.com/Images/fx/amtf/amtf-21.jpg"
                }
            };

            function a(){

                var video = document.querySelector('audio');
                var span1 = document.querySelector('div#span1');
                var span2 = document.querySelector('div#span2');

                if (!video.textTracks) return;

                var track = video.textTracks[0];
                track.mode = 'hidden';

                var idx = 0;

                track.oncuechange = function(e) {

                    var cue = this.activeCues[0];
                    if (cue) {
                        if (idx == 0) {
                            span2.className = '';
                            span1.classList.remove('on');
                            span1.innerHTML = '';
                            span1.appendChild(cue.getCueAsHTML());
                            span1.classList.add('on');
                        } else {
                            span1.className = '';
                            span2.classList.remove('on');
                            span2.innerHTML = '';
                            span2.appendChild(cue.getCueAsHTML());
                            span2.classList.add('on');
                        }

                        idx = ++idx % 2;
                    }

                };
            };
            setTimeout(a, 1000);
        });

        controller.showList = true;
        controller.showFilter = false;


        controller.setVideo = function (index) {
            controller.API.stop();
            controller.currentVideo = index;
            controller.currentVideoTitle = controller.videos[index].text;
            controller.config.sources = controller.videos[index].sound_url;
            $timeout(controller.API.play.bind(controller.API), 100);
        };
    }]);