# சுழற்சி தூரம்

கிளிப்பரில் உள்ள ச்டெப்பர் மின்னோடி டிரைவர்களுக்கு ஒவ்வொரு [ச்டெப்பர் கட்டமைப்பு பிரிவிலும்] `சுழற்சி_டிச்டன்ச்` அளவுரு தேவைப்படுகிறது (config_reference.md#ச்டெப்பர்). `சுழற்சி_டிச்டன்ச்` என்பது ச்டெப்பர் மோட்டரின் ஒரு முழு புரட்சியுடன் அச்சு நகரும் தூரத்தின் அளவு. இந்த மதிப்பை ஒருவர் எவ்வாறு உள்ளமைக்க முடியும் என்பதை இந்த ஆவணம் விவரிக்கிறது.

## Steps_per_mm (அல்லது step_distance) இலிருந்து சுழற்சி_ டிச்டன்ச் பெறுதல்

உங்கள் 3D அச்சுப்பொறியின் வடிவமைப்பாளர்கள் முதலில் சுழற்சி தூரத்திலிருந்து `STEPS_PER_MM` கணக்கிட்டனர். Steps_per_mm உங்களுக்குத் தெரிந்தால், அந்த அசல் சுழற்சி தூரத்தைப் பெற இந்த பொது சூத்திரத்தைப் பயன்படுத்த முடியும்:

```
சுழற்சி_டிச்டன்ச் = <full_steps_per_rotation> * <மைக்ரோச்டெப்ச்> / <படிகள்_பெர்_எம்எம்>
```

அல்லது, உங்களிடம் பழைய கிளிப்பர் உள்ளமைவு இருந்தால், `Step_distance` அளவுருவை அறிந்திருந்தால், இந்த சூத்திரத்தைப் பயன்படுத்தலாம்:

```
சுழற்சி_டிச்டன்ச் = <full_steps_per_rotation> * <மைக்ரோச்டெப்ச்> * <step_distance>
```

`<full_steps_per_rotation>` அமைப்பு ச்டெப்பர் மின்னோடி வகையிலிருந்து தீர்மானிக்கப்படுகிறது. பெரும்பாலான ச்டெப்பர் மோட்டார்கள் "1.8 டிகிரி ச்டெப்பர்கள்", எனவே ஒரு சுழற்சிக்கு 200 முழு படிகள் உள்ளன (360 1.8 ஆல் வகுக்கப்படுகிறது 200). சில ச்டெப்பர் மோட்டார்கள் "0.9 டிகிரி ச்டெப்பர்கள்", இதனால் சுழற்சிக்கு 400 முழு படிகள் உள்ளன. மற்ற ச்டெப்பர் மோட்டார்கள் அரிதானவை. உறுதியாக தெரியவில்லை என்றால், கட்டமைப்பு கோப்பில் full_steps_per_rotation ஐ அமைத்து மேலே உள்ள சூத்திரத்தில் 200 ஐப் பயன்படுத்தவும்.

`<மைக்ரோச்டெப்ச்>` அமைப்பு ச்டெப்பர் மின்னோடி டிரைவரால் தீர்மானிக்கப்படுகிறது. பெரும்பாலான ஓட்டுநர்கள் 16 மைக்ரோச்டெப்சைப் பயன்படுத்துகின்றனர். உறுதியாக தெரியவில்லை என்றால், `மைக்ரோச்டெப்ச்: 16` கட்டமைப்பில் அமைத்து மேலே உள்ள சூத்திரத்தில் 16 ஐப் பயன்படுத்தவும்.

கிட்டத்தட்ட எல்லா அச்சுப்பொறிகளும் ஃச், ஒய் மற்றும் சட் வகை அச்சுகளில் `சுழற்சி_டிச்டன்ச்` க்கான முழு எண்ணைக் கொண்டிருக்க வேண்டும். மேலே உள்ள தேற்றம் ஒரு முழு எண்ணின் .01 க்குள் இருக்கும் ஒரு சுழற்சி_டி நிலைக்கு விளைகிறது என்றால், இறுதி மதிப்பை அந்த முழு_நம்பருக்குச் சுற்றி வையுங்கள்.

## எக்ச்ட்ரூடர்கள் மீதான சுழற்சி_ டிச்டன்ச் அளவீடு

ஒரு எக்ச்ட்ரூடரில், `சுழற்சி_டிச்டன்ச்` என்பது ச்டெப்பர் மோட்டரின் ஒரு முழு சுழற்சிக்கான இழை பயணிக்கும் தூரத்தின் அளவு. இந்த அமைப்பிற்கான துல்லியமான மதிப்பைப் பெறுவதற்கான சிறந்த வழி "அளவீடு மற்றும் டிரிம்" நடைமுறையைப் பயன்படுத்துவதாகும்.

சுழற்சி தூரத்திற்கு ஆரம்ப யூகத்துடன் முதலில் தொடங்கவும். இது [Steps_per_mm] இலிருந்து பெறப்படலாம் (#-rotation_distance-from-steps_per_mm-or-step_distance) அல்லது [வன்பொருளை ஆய்வு செய்தல்] (#எக்ச்ட்ரூடர்) மூலம் பெறலாம்.

"அளவிட மற்றும் ஒழுங்கமைக்க" பின்வரும் நடைமுறையைப் பயன்படுத்தவும்:

1. எக்ச்ட்ரூடருக்கு அதில் இழை இருப்பதை உறுதிசெய்து கொள்ளுங்கள், ஒட்டெண்ட் பொருத்தமான வெப்பநிலைக்கு வெப்பப்படுத்தப்படுகிறது, மேலும் அச்சுப்பொறி வெளியேற்றத் தயாராக உள்ளது.
1. எக்ச்ட்ரூடர் உடலை உட்கொள்வதிலிருந்து 70 மி.மீ. தொலைவில் உள்ள இழைகளில் ஒரு அடையாளத்தை வைக்க ஒரு மார்க்கரைப் பயன்படுத்தவும். அந்த அடையாளத்தின் உண்மையான தூரத்தை ஒருவரால் முடிந்தவரை அளவிட டிசிட்டல் காலிப்பர்களைப் பயன்படுத்தவும். இதை `<siturd_mark_distance>` என கவனியுங்கள்.
1. பின்வரும் கட்டளை வரிசையுடன் 50 மிமீ இழை எக்ச்ட்ரூட்: `G91` அதைத் தொடர்ந்து` G1 E50 F60`. குறிப்பு 50 மிமீ `<septied_extrude_distance>`. எக்ச்ட்ரூடர் இந்த நடவடிக்கையை முடிக்க காத்திருங்கள் (இது சுமார் 50 வினாடிகள் எடுக்கும்). இந்த சோதனைக்கு மெதுவான வெளியேற்ற விகிதத்தை வேகமான விகிதமாகப் பயன்படுத்துவது முதன்மை, ஏனெனில் எக்ச்ட்ரூடரில் அதிக அழுத்தத்தை ஏற்படுத்தும், இது முடிவுகளைத் தவிர்க்கும். (இந்த சோதனைக்கு வரைகலை முன் முனைகளில் "எக்ச்ட்ரூட் பொத்தானை" பயன்படுத்த வேண்டாம், ஏனெனில் அவை வேகமான விகிதத்தில் எக்ச்ட்ரூட்.)
1. எக்ச்ட்ரூடர் உடலுக்கும் இழையின் அடையாளத்திற்கும் இடையிலான புதிய தூரத்தை அளவிட டிசிட்டல் காலிப்பர்களைப் பயன்படுத்தவும். இதை `<அடுத்தடுத்த_மார்க்_டிச்டன்ச்>` என கவனியுங்கள். பின்னர் கணக்கிடுங்கள்: `ரியல்_எக்ச்ட்ரூட்_டிச்டன்ச் = <itither_mark_distance> - <rentent_mark_distance>`
1. சுழற்சியைக் கணக்கிடுங்கள்: `சுழற்சி_டிச்டன்ச் = <முந்தைய_ரோட்டேசன்_டிச்டன்ச்> * <உண்மையான_எக்ச்ட்ரூட்_டிச்டன்ச்> / <nuptioned_extrude_distance>` புதிய சுழற்சி_ டிச்டென்சை மூன்று தசம இடங்களுக்குச் சுற்றவும்.

உண்மையான_எக்ச்ட்ரூட்_டிச்டன்ச் கோரப்பட்ட எக்ச்ட்ரூட் தூரத்திலிருந்து சுமார் 2 மிமீக்கு வேறுபட்டால், இரண்டாவது முறையாக படிகளைச் செய்வது நல்லது.

குறிப்பு: ஃச், ஒய், அல்லது சட் வகை அச்சுகளை அளவீடு செய்ய "அளவீடு மற்றும் டிரிம்" வகையைப் பயன்படுத்த வேண்டாம். "அளவீடு மற்றும் டிரிம்" முறை அந்த அச்சுகளுக்கு போதுமான துல்லியமாக இல்லை, மேலும் இது மோசமான உள்ளமைவுக்கு வழிவகுக்கும். அதற்கு பதிலாக, தேவைப்பட்டால், அந்த அச்சுகளை [பெல்ட்கள், புல்லிகள் மற்றும் முன்னணி திருகு வன்பொருளை அளவிடுவதன் மூலம்] தீர்மானிக்க முடியும் (##-ROTATION_DISTANCE-BY-INSTECT-HARDWARE ஐப் பெறுதல்).

## வன்பொருளை ஆய்வு செய்வதன் மூலம் சுழற்சி_ டிச்டன்ச் பெறுதல்

ச்டெப்பர் மோட்டார்கள் மற்றும் அச்சுப்பொறி இயக்கவியல் பற்றிய அறிவைக் கொண்டு சுழற்சி_டையை கணக்கிட முடியும். படிகள்_பெர்_எம்எம் அறியப்படாவிட்டால் அல்லது புதிய அச்சுப்பொறியை வடிவமைத்தால் இது பயனுள்ளதாக இருக்கும்.

### பெல்ட் உந்துதல் அச்சுகள்

ஒரு பெல்ட் மற்றும் கப்பி பயன்படுத்தும் ஒரு நேரியல் அச்சுக்கு சுழற்சி_டி கணக்கிடுவது எளிது.

முதலில் பெல்ட் வகையை தீர்மானிக்கவும். பெரும்பாலான அச்சுப்பொறிகள் 2 மிமீ பெல்ட் சுருதியைப் பயன்படுத்துகின்றன (அதாவது, பெல்ட்டில் உள்ள ஒவ்வொரு பல்லும் 2 மிமீ இடைவெளியில் இருக்கும்). பின்னர் ச்டெப்பர் மின்னோடி கப்பி மீது பற்களின் எண்ணிக்கையை எண்ணுங்கள். சுழற்சி_டெச்டன்ச் பின்னர் கணக்கிடப்படுகிறது:

```
சுழற்சி_டிச்டன்ச் = <pelt_pitch> * <number_of_teeth_on_pulley>
```

எடுத்துக்காட்டாக, ஒரு அச்சுப்பொறிக்கு 2 மிமீ பெல்ட் உள்ளது மற்றும் 20 பற்களைக் கொண்ட ஒரு கப்பி பயன்படுத்தினால், சுழற்சி தூரம் 40 ஆகும்.

### ஒரு முன்னணி திருகு கொண்ட அச்சுகள்

பின்வரும் சூத்திரத்தைப் பயன்படுத்தி பொதுவான முன்னணி திருகுகளுக்கான சுழற்சி_டென்சனைக் கணக்கிடுவது எளிது:

```
சுழற்சி_டிச்டன்ச் = <chrue_pitch> * <number_of_separate_threads>
```

எடுத்துக்காட்டாக, பொதுவான "டி 8 லீட்ச்க்ரூ" 8 இன் சுழற்சி தூரத்தைக் கொண்டுள்ளது (இது 2 மிமீ சுருதி மற்றும் 4 தனித்தனி நூல்களைக் கொண்டுள்ளது).

"திரிக்கப்பட்ட தண்டுகள்" கொண்ட பழைய அச்சுப்பொறிகள் ஈய திருகு மீது ஒரே "நூல்" மட்டுமே உள்ளன, இதனால் சுழற்சி தூரம் திருகு சுருதி ஆகும். .

### எக்ச்ட்ரூடர்

இழைகளைத் தள்ளும் "ஆர்டட் போல்ட்டின்" விட்டம் அளவிடுவதன் மூலமும், பின்வரும் சூத்திரத்தைப் பயன்படுத்துவதன் மூலமும் எக்ச்ட்ரூடர்களுக்கு ஆரம்ப சுழற்சி தூரத்தைப் பெற முடியும்: `சுழற்சி_டிச்டன்ச் = <விட்டம்> * 3.14`

எக்ச்ட்ரூடர் கியர்களைப் பயன்படுத்தினால், எக்ச்ட்ரூடருக்கு [கியர்_ராட்டியோவை தீர்மானித்து அமைக்கவும்] (#-ஒரு கியர்_ராட்டியோவைப் பயன்படுத்துதல்) (#-gear_ratio ஐப் பயன்படுத்துதல்) அவசியமாக இருக்கும்.

ஒரு எக்ச்ட்ரூடரில் உண்மையான சுழற்சி தூரம் அச்சுப்பொறியில் இருந்து அச்சுப்பொறிக்கு மாறுபடும், ஏனெனில் இழை ஈடுபடும் "ஆர்டட் போல்ட்" இன் பிடியில் மாறுபடும். இது இழை ச்பூல்களுக்கு இடையில் கூட மாறுபடும். ஆரம்ப சுழற்சி_டனலைப் பெற்ற பிறகு, மிகவும் துல்லியமான அமைப்பைப் பெற [அளவீடு மற்றும் டிரிம் செயல்முறை] (#அளவீடு-ரோட்டேசன்_டிச்டன்ச்-ஆன்-எக்ச்ட்ரூடர்கள்) ஐப் பயன்படுத்தவும்.

## கியர்_ராட்டியோவைப் பயன்படுத்துதல்

ஒரு `கியர்_ராட்டியோ` அமைப்பது கியர் பெட்டியை (அல்லது ஒத்த) இணைக்கப்பட்டுள்ள ச்டெப்பர்களில்` சுழற்சி_டிச்டன்ச்` ஐ கட்டமைப்பதை எளிதாக்கும். பெரும்பாலான ச்டெப்பர்களுக்கு கியர் பெட்டி இல்லை - உறுதியாக இருந்தால் கட்டமைப்பில் `கியர்_ராட்டியோ` அமைக்க வேண்டாம்.

`கியர்_ராட்டியோ` அமைக்கப்படும்போது,` சுழற்சி_டிச்டன்ச்` கியர் பெட்டியில் இறுதி கியரின் ஒரு முழு சுழற்சியுடன் அச்சு நகரும் தூரத்தை குறிக்கிறது. எடுத்துக்காட்டாக, ஒருவர் "5: 1" விகிதத்துடன் கியர்பாக்சைப் பயன்படுத்தினால், ஒருவர் [வன்பொருளின் அறிவு] (#-rotation_distance-by-instepling-hardware ஐப் பெறுதல்) உடன் சுழற்சி_டையை கணக்கிட முடியும், பின்னர் `சேர்க்கவும்` கியர்_ராட்டியோ: கட்டமைப்பிற்கு 5: 1`.

பெல்ட்கள் மற்றும் புல்லிகளுடன் செயல்படுத்தப்பட்ட கியரிங்கிற்கு, புல்லிகளில் பற்களை எண்ணுவதன் மூலம் கியர்_ராட்டியோவை தீர்மானிக்க முடியும். எடுத்துக்காட்டாக, 16 பல் கப்பி கொண்ட ஒரு ச்டெப்பர் 80 பற்களுடன் அடுத்த கப்பி ஓட்டினால், ஒருவர் `கியர்_ராட்டியோ: 80: 16` ஐப் பயன்படுத்துவார். உண்மையில், ஒருவர் அலமாரியில் இருந்து "கியர் பெட்டியில்" ஒரு பொதுவானதைத் திறந்து அதன் கியர் விகிதத்தை உறுதிப்படுத்த அதில் உள்ள பற்களை எண்ணலாம்.

சில நேரங்களில் கியர்பாக்ச் விளம்பரப்படுத்தப்பட்டதை விட சற்று மாறுபட்ட கியர் விகிதத்தைக் கொண்டிருக்கும் என்பதை நினைவில் கொள்க. பொதுவான பி.எம்.சி எக்ச்ட்ரூடர் மின்னோடி கியர்கள் இதற்கு ஒரு எடுத்துக்காட்டு - அவை "3: 1" என விளம்பரப்படுத்தப்படுகின்றன, ஆனால் உண்மையில் "50:17" பியரிங் பயன்படுத்துகின்றன. . `.

ஒரு அச்சில் பல கியர்கள் பயன்படுத்தப்பட்டால், கமா பிரிக்கப்பட்ட பட்டியலை கியர்_ராட்டியோவுக்கு வழங்க முடியும். எடுத்துக்காட்டாக, 80 பல் கொண்ட கப்பி வரை 16 டூட் முதல் "5: 1" கியர் பெட்டி `கியர்_ராட்டியோ: 5: 1, 80: 16` ஐப் பயன்படுத்தலாம்.

பெரும்பாலான சந்தர்ப்பங்களில், பொதுவான கியர்கள் மற்றும் புல்லிகள் அவற்றில் முழு எண்ணிக்கையிலான பற்களைக் கொண்டிருப்பதால் கியர்_ரேட்டியோ முழு எண்களுடன் வரையறுக்கப்பட வேண்டும். இருப்பினும், ஒரு பெல்ட் பற்களுக்கு பதிலாக உராய்வைப் பயன்படுத்தி ஒரு கப்பி ஓட்டும் சந்தர்ப்பங்களில், கியர் விகிதத்தில் மிதக்கும் புள்ளி எண்ணைப் பயன்படுத்துவது அர்த்தமுள்ளதாக இருக்கலாம் (எ.கா., `கியர்_ரேட்டியோ: 107.237: 16`).
