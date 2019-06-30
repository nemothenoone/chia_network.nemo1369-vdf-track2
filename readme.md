# Chia Network VDF

## Implementation Description

This particular implementation contains both optimizations, algorithmic and hardware-driven.

### Algorithmic Optimizations

This particular implementation advances the 'NUDPL'-enabled implementation with removing redundant copying and type-conversions, which actually gave about 10% performance increase.

Reduction steps are replaced with approximation algorithm proposed in the round 1 with the only difference - 
termination condition threshold is increased to 64 bit. That is done so because 
of NUDPL-generated coefficients are far more smaller, than 2048 bit, the reduction itself is required to "smooth" 
them to fully reduced ones. Such approximation algorithm usage in combination with NUDPL makes the performance about 
10% better. 

Normalization steps are optimized for handling particular values of already normalized form with no redundant copying.

### SIMD Optimizations