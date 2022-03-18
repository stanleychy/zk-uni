/*
    Prove: I know (x1,y1,x2,y2,x3,y3,energy) such that:
    - (y3-y2)(x2-x1) != (x3-x2)(y2-y1)
    - (x1-x2)^2 + (y1-y2)^2 <= energy^2
    - (x2-x3)^2 + (y3-y3)^2 <= energy^2
    - (x3-x1)^2 + (y3-y1)^2 <= energy^2
    - MiMCSponge(x1,y1) = pub1
    - MiMCSponge(x2,y2) = pub2
    - MiMCSponge(x3,y3) = pub3
*/
pragma circom 2.0.3;

include "../../node_modules/circomlib/circuits/mimcsponge.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template Main() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input x3;
    signal input y3;
    signal input energy;

    signal output pub1;
    signal output pub2;
    signal output pub3;

    /* check (x1-x2)^2 + (y1-y2)^2 <= energy^2 */

    signal xDiffAB;
    xDiffAB <== x1 - x2;
    signal yDiffAB;
    yDiffAB <== y1 - y2;

    component ltDist1 = LessThan(32);
    signal xDiffABSquare;
    signal yDiffABSquare;
    xDiffABSquare <== xDiffAB * xDiffAB;
    yDiffABSquare <== yDiffAB * yDiffAB;
    ltDist1.in[0] <== xDiffABSquare + yDiffABSquare;
    ltDist1.in[1] <== energy * energy + 1;
    ltDist1.out === 1;

    /* check (x2-x3)^2 + (y2-y3)^2 <= energy^2 */
    signal xDiffBC;
    xDiffBC <== x2 - x3;
    signal yDiffBC;
    yDiffBC <== y2 - y3;

    component ltDist2 = LessThan(32);
    signal xDiffBCSquare;
    signal yDiffBCSquare;
    xDiffBCSquare <== xDiffBC * xDiffBC;
    yDiffBCSquare <== yDiffBC * yDiffBC;
    ltDist2.in[0] <== xDiffBCSquare + yDiffBCSquare;
    ltDist2.in[1] <== energy * energy + 1;
    ltDist2.out === 1;

    /* check (x3-x1)^2 + (y3-y1)^2 <= energy^2 */
    signal xDiffCA;
    xDiffCA <== x3 - x1;
    signal yDiffCA;
    yDiffCA <== y3 - y1;

    component ltDist3 = LessThan(32);
    signal xDiffCASquare;
    signal yDiffCASquare;
    xDiffCASquare <== xDiffCA * xDiffCA;
    yDiffCASquare <== yDiffCA * yDiffCA;
    ltDist3.in[0] <== xDiffCASquare + yDiffCASquare;
    ltDist3.in[1] <== energy * energy + 1;
    ltDist3.out === 1;

    /* check (y3-y2)(x2-x1) != (x3-x2)(y2-y1) */
    component equal = IsEqual();
    equal.in[0] <== yDiffAB * xDiffBC;
    equal.in[1] <== xDiffAB * yDiffBC;
    equal.out === 0;

    /* check MiMCSponge(x1,y1) = pub1, MiMCSponge(x2,y2) = pub2, MiMCSponge(x3y3) = pub3 */
    /*
        220 = 2 * ceil(log_5 p), as specified by mimc paper, where
        p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
    */
    component mimc1 = MiMCSponge(2, 220, 1);
    component mimc2 = MiMCSponge(2, 220, 1);
    component mimc3 = MiMCSponge(2, 220, 1);

    mimc1.ins[0] <== x1;
    mimc1.ins[1] <== y1;
    mimc1.k <== 0;

    mimc2.ins[0] <== x2;
    mimc2.ins[1] <== y2;
    mimc2.k <== 0;

    mimc3.ins[0] <== x3;
    mimc3.ins[1] <== y3;
    mimc3.k <== 0;

    pub1 <== mimc1.outs[0];
    pub2 <== mimc2.outs[0];
    pub3 <== mimc3.outs[0];
}

component main = Main();