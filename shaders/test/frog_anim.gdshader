shader_type canvas_item;
render_mode unshaded;

// 화면 뒤를 샘플링하기 위한 스크린 텍스처
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_nearest;

// 교체할 두 색 (sRGB 기준 입력: #4a5b47, #fffdf9)
const vec3 color_a_srgb = vec3(0.290196, 0.356863, 0.278431); // #4a5b47
const vec3 color_b_srgb = vec3(1.000000, 0.992157, 0.976471); // #fffdf9

// 허용 오차 (선형 색공간 기준)
uniform float tol = 0.02;

// sRGB → 선형 보정
vec3 srgb_to_linear(vec3 c) {
    // Godot 4는 셰이더 내부가 선형 색공간이라 상수는 직접 보정해 주는 게 안전합니다.
    return pow(c, vec3(2.2));
}

void fragment() {
    // 뒤에 그려진 화면을 그대로 샘플
    vec3 col = texture(screen_tex, SCREEN_UV).rgb;

    // 비교는 선형 공간에서
    vec3 a = srgb_to_linear(color_a_srgb);
    vec3 b = srgb_to_linear(color_b_srgb);
    vec3 lin = srgb_to_linear(col);

    // color_a 근처면 b로, color_b 근처면 a로 스왑
    vec3 out_lin = lin;
    if (distance(lin, a) < tol) {
        out_lin = b;
    } else if (distance(lin, b) < tol) {
        out_lin = a;
    }

    // 선형 → sRGB로 되돌려 출력
    vec3 out_srgb = pow(out_lin, vec3(1.0/2.2));
    COLOR = vec4(out_srgb, 1.0);
}
