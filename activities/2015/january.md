January
=======

1st week
--------

-   Still at Christmas's holidays!

2nd week
--------

-   Importing `lsd_slam` code into QtCreator for better code navigation
    and understanding
-   Breaking `lsd_slam` module into small reusable pieces of code for a
    semi-dense map reconstruction
-   Removing ROS dependencies from the code.
-   Adjusting camera calibration with PTAM using the following
    parameters: `[ 0.507403 0.731726 0.449718 1.00829 0.0278688 ]`
-   Created a little [roslaunch](http://wiki.ros.org/roslaunch/XML) file
    to automate the execution of the mapper and viewer in a single command:

<!-- -->

    <launch>
    <node name="webcam" pkg="usb_cam" type="usb_cam_node" output="screen" >
    <param name="video_device" value="/dev/video0" />
    <param name="image_width" value="640" />
    <param name="image_height" value="480" />
    <param name="pixel_format" value="mjpeg" />
    <param name="camera_frame_id" value="usb_cam" />
    <param name="io_method" value="mmap"/>
    </node>
    <node name="mapper" pkg="lsd_slam_core" type="live_slam" respawn="false" output="screen">
    <remap from="image" to="/usb_cam/image_raw" />
    <param name="calib" value="src/lsd_slam/lsd_slam_core/calib/OpenCV_example_calib.cfg" />
    </node>
    <node name="viewer" pkg="lsd_slam_viewer" type="viewer" respawn="false" output="screen" />
    </launch>
