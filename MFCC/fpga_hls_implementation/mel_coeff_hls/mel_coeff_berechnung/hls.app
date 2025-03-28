<project xmlns="com.autoesl.autopilot.project" name="mel_coeff_berechnung" top="mel_filterbank" projectType="C/C++">
    <includePaths/>
    <libraryPaths/>
    <Simulation argv="">
        <SimFlow name="csim" ldflags="" clean="true" csimMode="0" lastCsimMode="0"/>
    </Simulation>
    <files xmlns="">
        <file name="hamming_window.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="hamming_window.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="mel_coefficients.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="mel_coefficients.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="mel_filterbank_lut.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="mel_filterbank_lut.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="../../test_mel.cpp" sc="0" tb="1" cflags="-Wno-unknown-pragmas" csimflags="" blackbox="false"/>
    </files>
    <solutions xmlns="">
        <solution name="mel_coeff_berechnung" status="active"/>
    </solutions>
</project>

