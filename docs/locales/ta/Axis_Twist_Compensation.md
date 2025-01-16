# அச்சு திருப்ப இழப்பீடு

இந்த ஆவணம் [AXIS_TWIST_COMPENSATION] தொகுதியை விவரிக்கிறது.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

இந்த தொகுதி ஆய்வின் முடிவுகளை சரிசெய்ய பயனரின் கையேடு அளவீடுகளைப் பயன்படுத்துகிறது. உங்கள் அச்சு கணிசமாக முறுக்கப்பட்டால், மென்பொருள் திருத்தங்களைப் பயன்படுத்துவதற்கு முன்பு அதை சரிசெய்ய முதலில் இயந்திர வழிமுறைகளைப் பயன்படுத்த பரிந்துரைக்கப்படுகிறது என்பதை நினைவில் கொள்க.

** எச்சரிக்கை **: இந்த தொகுதி இன்னும் கப்பல்துறை ஆய்வுகளுடன் பொருந்தவில்லை, மேலும் நீங்கள் அதைப் பயன்படுத்தினால் அதை இணைக்காமல் படுக்கையை ஆய்வு செய்ய முயற்சிக்கும்.

## இழப்பீட்டு பயன்பாட்டின் கண்ணோட்டம்

> ** உதவிக்குறிப்பு: ** [ஆய்வு ஃச் மற்றும் ஒய் ஆஃப்செட்டுகள்] (config_reference.md#ஆய்வு) அளவுத்திருத்தத்தை பெரிதும் பாதிக்கும்போது சரியாக அமைக்கப்படுவதை உறுதிசெய்க.

1. [AXIS_TWIST_COMPENSATION] தொகுதியை அமைத்த பிறகு, `AXIS_TWIST_COMPENSATION_CALIBRATE` ஐச் செய்யுங்கள்

* அளவுத்திருத்த வழிகாட்டி படுக்கையுடன் ஒரு சில புள்ளிகளில் ஆய்வு சட் ஆஃப்செட்டை அளவிட உங்களைத் தூண்டும்
* அளவுத்திருத்தம் 3 புள்ளிகளுக்கு இயல்புநிலையாகிறது, ஆனால் நீங்கள் வேறு எண்ணைப் பயன்படுத்த `மாதிரி_சவுண்ட் =` விருப்பத்தைப் பயன்படுத்தலாம்.

1. [Adjust your சட் offset](Probe_Calibrate.md#calibrating-probe-z-offset)
1. [திருகுகள் சாய் சரிசெய்தல்] (சி-கோட்ச்.
1. முகப்பு அனைத்து அச்சுகளும், பின்னர் தேவைப்பட்டால் [படுக்கை கண்ணி] (BED_MESH.MD) செய்யுங்கள்
1. ஒரு சோதனை அச்சுப்பொறியைச் செய்யுங்கள், அதைத் தொடர்ந்து [நன்றாக-ட்யூனிங்] (அச்சு_ட்விச்ட்_காம்பென்சேசன். எம்.டி#ஃபைன்-ட்யூனிங்) விரும்பியபடி

> ** உதவிக்குறிப்பு: ** படுக்கை வெப்பநிலை மற்றும் முனை வெப்பநிலை மற்றும் அளவு அளவுத்திருத்த செயல்முறைக்கு செல்வாக்கு இருப்பதாகத் தெரியவில்லை.

## [AXIS_TWIST_COMPENSATION] அமைப்பு மற்றும் கட்டளைகள்

[AXIS_TWIST_COMPENSATION] க்கான உள்ளமைவு விருப்பங்கள் [உள்ளமைவு குறிப்பு] (config_reference.md#அச்சு_ட்விச்ட்_பென்சேசன்) இல் காணலாம்.

[AXIS_TWIST_COMPENSATION] க்கான கட்டளைகளை [G- குறியீடுகள்] (g-codes.md#axin_twist_compensation) இல் காணலாம்)
