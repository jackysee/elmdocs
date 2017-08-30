# Quaternions

_Impossible transforms are inexpressible_

[![Build status](https://travis-ci.org/kfish/quaternion.svg?branch=master)][travis]

[travis]: https://travis-ci.org/kfish/quaternion

<!--
Quaternions have the following advantages over matrix transformations:

* No gimbal lock
* No impossible transforms
* Faster

with the primary disadvantage being that quaternions are more difficult to
understand.

A design goal of this library is to be easy to understand.

The underlying problem of representing rotations in 3D space is inherently difficult.
-->

## Motivation

<!--
Can express rotations, but not shearing, scaling or translations

Translations are trivial

Shearing and scaling don't happen in the real world

Scaling is trivial

So, a combination of translation and orientation (via quaternions)
is everything you need for world transforms.

Also, quaternions are faster than matrices due to 4 components not 9.
-->

[How I learned to Stop Worrying and Love Quaternions](http://developerblog.myo.com/quaternions/)

[Animate your way to glory](http://acko.net/blog/animate-your-way-to-glory/)

## Background

[Wikipedia: Quaternion](https://en.wikipedia.org/wiki/Quaternion)

### Euler angles

[Wikipedia: Conersion between quaternions and Euler angles](https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles)

## Uses

### Spatial rotation

[Wikipedia: Quaternions and spatial rotation](https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation)

### Flight dynamics

[USE OF QUATERNIONS IN FLIGHT MECHANICS](http://www.dtic.mil/dtic/tr/fulltext/u2/a152616.pdf)

[NPSNET: FLIGHT SIMULATION DYNAMIC MODELING USING QUATERNIONS](http://www.movesinstitute.org/~zyda/pubs/Presence.1.4.pdf)

### Device orientation

[W3C DeviceOrientation Event Specification](https://www.w3.org/TR/orientation-event/)

[Practical Application and Usage of the W3C Device Orientation API](http://dev.opera.com/articles/w3c-device-orientation-usage/)

## References

[Euclidean Space: Quaternions](http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/)

[3D Game Engine Programming: Understanding Quaternions](https://www.3dgep.com/understanding-quaternions/)

@BrettHoutz paper on [Quaternions](https://people.ucsc.edu/~bhoutz/quaternions.pdf)

[Quaternions in Classical Mechanics](http://stahlke.org/dan/publications/quaternion-paper.pdf)
