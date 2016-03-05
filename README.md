# Introducing the Humble_RPi-plugin-TiltSensor gem

## Testing the plugin

    require 'humble_rpi-plugin-tiltsensor'

    class Echo

      def notice(s)
        puts "%s: %s" % [Time.now, s]
      end
    end

    sensor = HumbleRPiPluginTiltSensor.new(settings: {pins: [4], \
                  duration: '10 seconds'}, variables: {notifier: Echo.new})
    sensor.start

Output:

<pre>
2016-03-05 18:37:05 +0000: pi/tilt/0: detected 7 times within the past 10 seconds
2016-03-05 18:37:27 +0000: pi/tilt/0: detected
2016-03-05 18:37:37 +0000: pi/tilt/0: detected 14 times within the past 10 seconds
</pre>

## Using the plugin with the HumbleRPi gem


    require 'humble_rpi'
    require 'humble_rpi-plugin-tiltsensor'

    r = HumbleRPi.new device_name: 'ottavia', sps_address: '192.168.4.140',\
      plugins: {TiltSensor: {pins: [4]} }
    r.start

## Resources

* humble_rpi-plugin-tiltsensor https://rubygems.org/gems/humble_rpi-plugin-tiltsensor
* 5 x SW 520D Ball Angle Tilt Sensor http://www.jamesrobertson.eu/cpages/2016/mar/05/5-x-sw-520d-ball-angle-tilt-sensor-ebay-co-uk.html
* Pedometer https://en.wikipedia.org/wiki/Pedometer

humblerpi gem plugin tilt sensor
