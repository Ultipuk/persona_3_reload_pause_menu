shader_type canvas_item;
// Hi! This is my first shader, so maybe its not the best at performance, but it makes the job.
//
// Used the following sites to know how the gaussian blur works:
// https://en.wikipedia.org/wiki/Gaussian_blur
// https://www.w3.org/Talks/2012/0125-HTML-Tehran/Gaussian.xhtml <- Helped a lot!

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture,repeat_disable, filter_nearest;
uniform float sigma: hint_range(0.1, 20.0) = 3.3; // Limited to 20 because of performance, if you want feel free to break it.


float gaussianDistribution(float x, float STD){ // STD stands for standard deviation
	return exp(-(x*x)/(2.*STD*STD))/(sqrt(2.*PI)*STD);
}

vec3 gaussianblur(sampler2D sampler, vec2 pos, vec2 pixel_size, float sigmaUsed, int radius){
    vec3 blurredPixel = vec3(0.0);
    float total_weight = 0.0;
	// Loop over the radius (tecnically its a square)
    for(int i = -radius ; i <= radius; i++){
        for(int j = -radius; j <= radius; j++){
			// Calculate the offset from the current pixel
			vec2 offset = vec2(float(i), float(j))*pixel_size;
			vec2 changedPos = pos + offset;

			// Calculate the weight based on the Gaussian distribution multiplying both dimentions (how far are X and Y form the center (pos))
			float weight = gaussianDistribution(float(i), sigmaUsed)*gaussianDistribution(float(j), sigmaUsed);
			// Add the weighted color value to the blurred pixel
			blurredPixel += texture(SCREEN_TEXTURE, changedPos).rgb * weight;
			total_weight += weight;
        }
    }
	// Normalize the blurred pixel color by the total weight
	blurredPixel/=total_weight;
    return blurredPixel;
}
void fragment() {
    vec3 PixelBlurred = gaussianblur(SCREEN_TEXTURE, SCREEN_UV, SCREEN_PIXEL_SIZE, sigma, 3);
    // The radius is 3*Sigma because it iFus the point where the Gaussian weight is near zero.
    COLOR = vec4(PixelBlurred, 1.);
}
