// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rod/ASE-Snow"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 5
		_TessMin( "Tess Min Distance", Float ) = 5
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_ToonRamp("Main Color", Color) = (0.5,0.5,0.5,1)
		_Color("Snow Color", Color) = (0.5,0.5,0.5,1)
		_MainTex("Snow Texture", 2D) = "white" {}
		_SnowTextureScale("Snow Texture Scale", Range( 0 , 2)) = 1
		_SnowTextureOpacity("Snow Texture Opacity", Range( 0 , 2)) = 0.1
		_SnowHeight("Snow Height", Range( 0 , 2)) = 0.4
		_SnowDepth("Snow Path Depth", Range( 0 , 2)) = 0.4
		_PathColor("Snow Path Color", Color) = (0.17,0.18,0.76,1)
		_SnowNoise("Snow Noise", 2D) = "white" {}
		_NoiseWeight("Noise Weight", Range( 0 , 2)) = 0.1
		_NoiseScale("Noise Scale", Range( 0 , 2)) = 0.1
		_EdgeColor("Snow Edge Color", Color) = (0.29,0.29,0.42,1)
		_EdgeWidth("Snow Edge Width", Range( 0 , 0.2)) = 0.2
		_BaseColor("Base Color", Color) = (0.51,0.51,0.51,1)
		_MainTexBase("Base Texture", 2D) = "white" {}
		_Scale("Base Scale", Range( 0 , 2)) = 1
		_Mask("Mask", 2D) = "white" {}
		_LightScaleValue("LightScaleValue", Range( 0 , 5)) = 2
		_SnowSmoothness("Snow Smoothness", Range( 0 , 1)) = 0
		_SparkleNoise("Sparkle Noise", 2D) = "white" {}
		_RimColor("Rim Color Snow", Color) = (0.5,0.5,0.5,1)
		_RimPower("Rim Power", Range( 0 , 20)) = 0.5
		_SparkleScale("Sparkle Scale", Range( 0 , 20)) = 1
		_SparkleCutoff("Sparkle Cutoff", Range( 0 , 10)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _SnowHeight;
		uniform float _NoiseWeight;
		uniform sampler2D _SnowNoise;
		uniform float _NoiseScale;
		uniform sampler2D _GlobalEffectRT;
		uniform float3 _Position;
		uniform float _OrthographicCamSize;
		uniform sampler2D _Mask;
		uniform float _SnowDepth;
		uniform float4 _EdgeColor;
		uniform float _EdgeWidth;
		uniform sampler2D _MainTexBase;
		uniform float _Scale;
		uniform float4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform float _SnowTextureScale;
		uniform float _SnowTextureOpacity;
		uniform float4 _Color;
		uniform float4 _PathColor;
		uniform float4 _ToonRamp;
		uniform float _LightScaleValue;
		uniform float _SparkleCutoff;
		uniform sampler2D _SparkleNoise;
		uniform float4 _SparkleNoise_ST;
		uniform float _SparkleScale;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform float _SnowSmoothness;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float NoiseScaleValue166 = _NoiseScale;
			float4 appendResult82 = (float4(( (ase_worldPos).xz * NoiseScaleValue166 * 5.0 ) , 0.0 , 0.0));
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult89 = normalize( ase_vertexNormal );
			float4 appendResult59 = (float4(( ( ( (ase_worldPos).xz - (_Position).xz ) / ( _OrthographicCamSize * 2.0 ) ) + 0.5 ) , 0.0 , 0.0));
			float RTEffectG218 = (( tex2Dlod( _GlobalEffectRT, float4( appendResult59.xy, 0, 0.0) ) * tex2Dlod( _Mask, float4( appendResult59.xy, 0, 0.0) ).a )).g;
			v.vertex.xyz += ( ( saturate( ( ( _SnowHeight * v.color.r ) + ( _NoiseWeight * v.color.r * tex2Dlod( _SnowNoise, float4( appendResult82.xy, 0, 0.0) ) ) ) ) * float4( normalizeResult89 , 0.0 ) ) - float4( ( normalizeResult89 * ( RTEffectG218 * saturate( v.color.r ) ) * _SnowDepth ) , 0.0 ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_148_0 = (ase_worldPos).zy;
			float NoiseScaleValue166 = _NoiseScale;
			float2 temp_output_150_0 = (ase_worldPos).xy;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 temp_cast_0 = (4.0).xxx;
			float3 temp_output_143_0 = saturate( pow( ( (WorldNormalVector( i , ase_vertexNormal )) * 1.4 ) , temp_cast_0 ) );
			float temp_output_154_0 = (temp_output_143_0).x;
			float4 lerpResult156 = lerp( tex2D( _SnowNoise, ( temp_output_148_0 * NoiseScaleValue166 ) ) , tex2D( _SnowNoise, ( temp_output_150_0 * NoiseScaleValue166 ) ) , temp_output_154_0);
			float2 temp_output_149_0 = (ase_worldPos).zx;
			float temp_output_155_0 = (temp_output_143_0).y;
			float4 lerpResult157 = lerp( lerpResult156 , tex2D( _SnowNoise, ( temp_output_149_0 * NoiseScaleValue166 ) ) , temp_output_155_0);
			float4 temp_cast_1 = (i.vertexColor.r).xxxx;
			float4 temp_cast_2 = (i.vertexColor.r).xxxx;
			float4 temp_output_197_0 = step( ( lerpResult157 * 0.6 ) , temp_cast_2 );
			float4 temp_output_207_0 = ( step( ( ( 0.6 - _EdgeWidth ) * lerpResult157 ) , temp_cast_1 ) * ( 1.0 - temp_output_197_0 ) );
			float4 lerpResult186 = lerp( tex2D( _MainTexBase, ( temp_output_148_0 * _Scale ) ) , tex2D( _MainTexBase, ( temp_output_150_0 * _Scale ) ) , temp_output_154_0);
			float4 lerpResult187 = lerp( lerpResult186 , tex2D( _MainTexBase, ( temp_output_149_0 * _Scale ) ) , temp_output_155_0);
			float4 temp_cast_3 = (i.vertexColor.r).xxxx;
			float4 temp_cast_4 = (i.vertexColor.r).xxxx;
			float4 lerpResult176 = lerp( tex2D( _MainTex, ( temp_output_148_0 * _SnowTextureScale ) ) , tex2D( _MainTex, ( temp_output_150_0 * _SnowTextureScale ) ) , temp_output_154_0);
			float4 lerpResult177 = lerp( lerpResult176 , tex2D( _MainTex, ( temp_output_149_0 * _SnowTextureScale ) ) , temp_output_155_0);
			float4 temp_cast_5 = (i.vertexColor.r).xxxx;
			float4 temp_cast_6 = (i.vertexColor.r).xxxx;
			float4 appendResult59 = (float4(( ( ( (ase_worldPos).xz - (_Position).xz ) / ( _OrthographicCamSize * 2.0 ) ) + 0.5 ) , 0.0 , 0.0));
			float RTEffectG218 = (( tex2D( _GlobalEffectRT, appendResult59.xy ) * tex2D( _Mask, appendResult59.xy ).a )).g;
			float4 temp_cast_9 = (i.vertexColor.r).xxxx;
			float4 lerpResult220 = lerp( ( ( _EdgeColor * temp_output_207_0 ) + ( ( lerpResult187 * ( 1.0 - ( temp_output_207_0 + temp_output_197_0 ) ) ) * _BaseColor ) + ( ( lerpResult177 * temp_output_197_0 ) * _SnowTextureOpacity ) + ( _Color * temp_output_197_0 ) ) , ( _PathColor * RTEffectG218 ) , saturate( ( RTEffectG218 * 2.0 * temp_output_197_0 ) ));
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult235 = normalize( ase_worldlightDir );
			float dotResult237 = dot( ase_worldNormal , normalizeResult235 );
			float smoothstepResult240 = smoothstep( 0.0 , ( dotResult237 + 0.06 ) , dotResult237);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_cast_11 = (_SparkleCutoff).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 uv0_SparkleNoise = i.uv_texcoord * _SparkleNoise_ST.xy + _SparkleNoise_ST.zw;
			float4 temp_cast_14 = (i.vertexColor.r).xxxx;
			o.Albedo = ( ( lerpResult220 * ( _ToonRamp + smoothstepResult240 ) * _LightScaleValue * float4( ase_lightColor.rgb , 0.0 ) ) + ( step( temp_cast_11 , ( tex2D( _SparkleNoise, ( ase_screenPosNorm * float4( uv0_SparkleNoise, 0.0 , 0.0 ) * _SparkleScale ).xy ) * tex2D( _SparkleNoise, ( uv0_SparkleNoise * _SparkleScale ) ) ) ) * temp_output_197_0 ) ).rgb;
			float4 temp_cast_16 = (i.vertexColor.r).xxxx;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult191 = dot( ase_worldViewDir , BlendNormals( ase_vertexNormal , lerpResult157.rgb ) );
			o.Emission = ( temp_output_197_0 * pow( ( 1.0 - dotResult191 ) , _RimPower ) * _RimColor ).rgb;
			o.Smoothness = _SnowSmoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
58;182;1822;729;6006.529;-329.1971;2.153815;True;True
Node;AmplifyShaderEditor.CommentaryNode;144;-2561.961,-1763.638;Float;False;1101.081;320.8414;Blend Normal;9;155;154;143;141;139;142;140;137;138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;138;-2545.279,-1700.587;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;158;-5075.521,-1384.467;Float;False;466.5794;380.8271;World Position Swizzle;4;147;149;148;150;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-5059.117,493.2212;Float;False;Property;_NoiseScale;Noise Scale;15;0;Create;True;0;0;False;0;0.1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-2284.839,-1555.428;Float;False;Constant;_Float4;Float 4;24;0;Create;True;0;0;False;0;1.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;137;-2326.973,-1701.265;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;153;-3885.659,-669.3593;Float;False;1015.743;682.6102;normal noise triplanar for x, y, z sides;8;169;171;170;168;146;152;151;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-2079.217,-1556.764;Float;False;Constant;_Float5;Float 5;24;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-4725.962,494.0121;Float;False;NoiseScaleValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;147;-5023.938,-1219.34;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-2104.506,-1681.051;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;150;-4765.711,-1113.357;Float;False;FLOAT2;0;1;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-3817.554,-370.7966;Float;False;166;NoiseScaleValue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;141;-1937.218,-1628.763;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;130;-5055.981,684.2393;Float;False;2408.613;727.3229;UV Mask and Effect;20;108;76;75;72;59;73;71;86;47;85;46;41;44;84;123;40;39;35;8;218;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;148;-4766.026,-1330.782;Float;False;FLOAT2;2;1;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-5027.271,856.0729;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;8;-5041.335,1034.489;Float;False;Global;_Position;_Position;2;1;[HideInInspector];Create;True;0;0;False;0;0,0,0;7.201365,20,-2.630996;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;143;-1778.217,-1628.763;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;145;-3835.135,-194.2569;Float;True;Property;_SnowNoise;Snow Noise;13;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SwizzleNode;149;-4770.257,-1223.508;Float;False;FLOAT2;2;0;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-3414.653,-577.1486;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-3426.419,-195.1832;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-4938.76,1282.094;Float;False;Constant;_Float1;Float 1;23;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;154;-1616.558,-1708.732;Float;False;FLOAT;0;1;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;146;-3198.486,-606.9197;Float;True;Property;_TextureSample3;Texture Sample 3;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;151;-3198.486,-222.9198;Float;True;Property;_TextureSample4;Texture Sample 4;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-5041.516,1199.445;Float;False;Global;_OrthographicCamSize;_OrthographicCamSize;23;1;[HideInInspector];Create;True;0;0;False;0;6;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-3421.115,-387.9338;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;39;-4795.773,917.4319;Float;False;FLOAT2;0;2;0;0;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;40;-4792.773,996.4308;Float;False;FLOAT2;0;2;0;0;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;155;-1617.951,-1555.508;Float;False;FLOAT;1;1;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;198;-503.6643,-853.739;Float;False;576.2;344.8;vertex colored primary;3;196;197;195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-4609.871,943.431;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;152;-3198.486,-414.9198;Float;True;Property;_TextureSample5;Texture Sample 5;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;156;-1259.997,-639.7491;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-4604.782,1110.097;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;208;-491.6845,-1734.54;Float;False;1261.962;378.1429;Vertex color edge;7;207;201;205;204;203;202;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-483.7196,-622.5254;Float;False;Constant;_Float6;Float 6;26;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-419.2354,-1590.246;Float;False;Property;_EdgeWidth;Snow Edge Width;18;0;Create;False;0;0;False;0;0.2;0.1;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-1060.347,-451.034;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;46;-4449.567,943.502;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-308.9888,-1687.768;Float;False;Constant;_Float7;Float 7;26;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-4384.767,1104.117;Float;False;Constant;_Float2;Float 2;23;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;202;-132.9269,-1661.925;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;185;-3906.232,-2251.447;Float;False;1023.8;670.2469;triplanar for base texture, x,y,z sides;8;27;184;183;182;181;180;179;178;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;194;-291.7298,-1110.935;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-4189.496,941.5739;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;175;-3919.403,-1449.902;Float;False;1053.903;654.3516;triplanar for snow texture for x, y, z sides;8;173;172;174;22;162;161;160;159;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-4029.293,1003.665;Float;False;Constant;_Float3;Float 3;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-307.6457,-757.5178;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;73;-3888.969,726.8016;Float;True;Global;_GlobalEffectRT;_GlobalEffectRT;16;1;[HideInInspector];Create;True;0;0;False;0;None;8aeb68f0fe8a04643be52e1d419290b7;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3870.811,-1282.352;Float;False;Property;_SnowTextureScale;Snow Texture Scale;8;0;Create;True;0;0;False;0;1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-540.849,769.126;Float;False;1112.657;593.5104;Snow Noise;8;87;82;80;124;81;79;78;167;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3888.199,-2159.142;Float;False;Property;_Scale;Base Scale;21;0;Create;False;0;0;False;0;1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-3805.465,943.295;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;197;-87.66431,-757.739;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-3888.969,1079.802;Float;True;Property;_Mask;Mask;22;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;15.67577,-1565.009;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;178;-3856.571,-1795.679;Float;True;Property;_MainTexBase;Base Texture;20;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;72;-3577.775,1010.575;Float;True;Property;_TextureSample0;Texture Sample 0;24;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;78;-480.4122,1027.001;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-3496.305,-994.8802;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;201;444.5497,-1471.525;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;205;193.2095,-1564.112;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;75;-3577.775,738.5747;Float;True;Property;_RTEffect;RTEffect;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;159;-3871.533,-1013.799;Float;True;Property;_MainTex;Snow Texture;7;0;Create;False;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-3488,-1376;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-3479.369,-2177.576;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-3482.691,-1791.474;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;162;-3216,-1408;Float;True;Property;_TextureSample11;Texture Sample 11;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;212;1017.911,-1735.081;Float;False;554.9216;361.9438;Base Texture Result;3;210;209;211;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;79;-275.69,1022.451;Float;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-3479.369,-1983.916;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;624.1298,-1561.387;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-345.4801,1183.005;Float;False;166;NoiseScaleValue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-3241.774,1042.575;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-265.602,1267.248;Float;False;Constant;_FloatFive;FloatFive;23;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;-3218.125,-2203.799;Float;True;Property;_TextureSample12;Texture Sample 12;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;268;3370.211,-1942.958;Float;False;1630.54;706.4512;Sparkles;11;24;262;261;256;251;254;258;257;265;23;250;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;160;-3216,-1024;Float;True;Property;_TextureSample9;Texture Sample 9;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;245;2355.742,-524.1716;Float;False;1545.297;508.3665;LightToonRamp;12;242;244;11;240;241;238;239;237;236;235;234;247;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;181;-3218.125,-1819.799;Float;True;Property;_TextureSample14;Texture Sample 14;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-3489.661,-1184;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;234;2412.876,-347.7477;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;250;3454.15,-1653.066;Float;True;Property;_SparkleNoise;Sparkle Noise;25;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;176;-1253.73,-1408;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;161;-3216,-1216;Float;True;Property;_TextureSample10;Texture Sample 10;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-62.82903,1028.249;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-72.81311,1183.78;Float;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;186;-1237.73,-2176;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;108;-3073.823,1038.019;Float;False;FLOAT;1;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;180;-3218.125,-2011.799;Float;True;Property;_TextureSample13;Texture Sample 13;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;209;1037.859,-1558.899;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;132;1378.573,582.53;Float;False;1614.788;926.2478;Vertex Displacement;16;109;97;101;89;17;98;118;90;116;96;94;92;91;16;10;219;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;193;-513.3414,-312.8107;Float;False;795.9529;313.3555;rim light for snow, blending in the noise texture;5;192;191;188;189;190;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;187;-1045.73,-2016;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;265;3729.682,-1462.089;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;235;2711.481,-347.6443;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;177;-1045.73,-1232;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;210;1189.928,-1558.899;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;236;2678.636,-486.9185;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;82;110.1692,1028.249;Float;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-2893.594,1038.385;Float;False;RTEffectG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;200;1004.621,-1270.677;Float;False;235.4679;177.8417;snow texture result;1;199;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;3725.058,-1343.927;Float;False;Property;_SparkleScale;Sparkle Scale;28;0;Create;True;0;0;False;0;1;0.1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;257;3720.657,-1872.005;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;265.5562,832.0057;Float;True;Property;_TextureSample1;Texture Sample 1;23;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;91;1495.987,989.5478;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;1416.723,-1690.125;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;239;2863.595,-236.4282;Float;False;Constant;_Float9;Float 9;24;0;Create;True;0;0;False;0;0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;4056.488,-1835.122;Float;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;224;2764.09,-776.003;Float;False;Constant;_Float8;Float 8;25;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;189;-491.7076,-264.8889;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;1684.271,-1159.682;Float;False;Property;_SnowTextureOpacity;Snow Texture Opacity;9;0;Create;True;0;0;False;0;0.1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;2750.963,-875.1644;Float;False;218;RTEffectG;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;1693.669,-1458.765;Float;False;Property;_BaseColor;Base Color;19;0;Create;True;0;0;False;1;;0.51,0.51,0.51,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;237;2901.998,-388.3755;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;1699.757,-2141.833;Float;False;Property;_EdgeColor;Snow Edge Color;17;0;Create;False;0;0;False;1;;0.29,0.29,0.42,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;1489.308,737.7178;Float;False;Property;_NoiseWeight;Noise Weight;14;0;Create;True;0;0;False;0;0.1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;1689.307,-965.2411;Float;False;Property;_Color;Snow Color;6;0;Create;False;0;0;False;1;;0.5,0.5,0.5,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;1489.848,630.7081;Float;False;Property;_SnowHeight;Snow Height;10;0;Create;True;0;0;False;0;0.4;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;1070.477,-1222.677;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;4052.342,-1456.254;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;256;4233.455,-1864.1;Float;True;Property;_TextureSample6;Texture Sample 6;26;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;2053.953,-2070.377;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;2074.169,-811.5931;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;2951.618,-764.0116;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;2061.073,-1477.275;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;241;3153.834,-284.0825;Float;False;Constant;_Float10;Float 10;24;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;2068.573,-1230.625;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;2707.126,-1070.112;Float;False;Property;_PathColor;Snow Path Color;12;0;Create;False;0;0;False;1;;0.17,0.18,0.76,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;251;4235.928,-1654.973;Float;True;Property;_TextureSample2;Texture Sample 2;26;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1859.294,680.931;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;1861.093,789.2698;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;190;-264.5393,-266.1412;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendNormalsNode;188;-264.2816,-104.9467;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;3039.018,-255.3437;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;219;1828.771,1251.344;Float;False;218;RTEffectG;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;2965.362,-1064.866;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;232;765.8032,-51.19131;Float;False;981.8431;410.7446;Emmission;4;229;29;230;231;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;4596.219,-1670.206;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;225;3108.511,-764.0876;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;116;1858.988,1331.082;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;90;2023.796,1150.344;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;3323.125,-470.3352;Float;False;Property;_ToonRamp;Main Color;5;0;Create;False;0;0;False;1;;0.5,0.5,0.5,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;240;3328.107,-301.419;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;4443.523,-1420.259;Float;False;Property;_SparkleCutoff;Sparkle Cutoff;29;0;Create;True;0;0;False;0;0.1;0.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;191;-16.91,-127.6743;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;2028.649,680.624;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;217;2489.919,-1273.649;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;244;3606.015,-319.5323;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;242;3330.342,-180.4884;Float;False;Property;_LightScaleValue;LightScaleValue;23;0;Create;True;0;0;False;0;2;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;220;3299.573,-1090.871;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;874.3935,91.81258;Float;False;Property;_RimPower;Rim Power;27;0;Create;True;0;0;False;0;0.5;0.1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;98;2165.193,681.1;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;1937.454,1411.204;Float;False;Property;_SnowDepth;Snow Path Depth;11;0;Create;False;0;0;False;0;0.4;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;247;3735.077,-134.9605;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;2071.865,1308.233;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;262;4838.997,-1354.99;Float;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;192;115.5818,-126.5623;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;89;2230.839,1150.25;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;4348.015,-336.7432;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;2528.882,1081.066;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;5103.673,-611.6567;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;230;1180.116,8.907829;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;229;873.8362,182.2222;Float;False;Property;_RimColor;Rim Color Snow;26;0;Create;False;0;0;False;0;0.5,0.5,0.5,1;0.5,0.5,0.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;2684.018,1148.612;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;1571.451,6.60533;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;248;5028.137,135.0693;Float;False;Property;_SnowSmoothness;Snow Smoothness;24;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;109;2843.455,1081.896;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;5267.371,-332.7507;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5472.159,-30.90195;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Rod/ASE-Snow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;5;5;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;137;0;138;0
WireConnection;166;0;9;0
WireConnection;139;0;137;0
WireConnection;139;1;140;0
WireConnection;150;0;147;0
WireConnection;141;0;139;0
WireConnection;141;1;142;0
WireConnection;148;0;147;0
WireConnection;143;0;141;0
WireConnection;149;0;147;0
WireConnection;169;0;148;0
WireConnection;169;1;168;0
WireConnection;171;0;150;0
WireConnection;171;1;168;0
WireConnection;154;0;143;0
WireConnection;146;0;145;0
WireConnection;146;1;169;0
WireConnection;151;0;145;0
WireConnection;151;1;171;0
WireConnection;170;0;149;0
WireConnection;170;1;168;0
WireConnection;39;0;35;0
WireConnection;40;0;8;0
WireConnection;155;0;143;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;152;0;145;0
WireConnection;152;1;170;0
WireConnection;156;0;146;0
WireConnection;156;1;151;0
WireConnection;156;2;154;0
WireConnection;44;0;123;0
WireConnection;44;1;84;0
WireConnection;157;0;156;0
WireConnection;157;1;152;0
WireConnection;157;2;155;0
WireConnection;46;0;41;0
WireConnection;46;1;44;0
WireConnection;202;0;203;0
WireConnection;202;1;19;0
WireConnection;47;0;46;0
WireConnection;47;1;85;0
WireConnection;195;0;157;0
WireConnection;195;1;196;0
WireConnection;59;0;47;0
WireConnection;59;2;86;0
WireConnection;59;3;86;0
WireConnection;197;0;195;0
WireConnection;197;1;194;1
WireConnection;204;0;202;0
WireConnection;204;1;157;0
WireConnection;72;0;71;0
WireConnection;72;1;59;0
WireConnection;174;0;150;0
WireConnection;174;1;22;0
WireConnection;201;0;197;0
WireConnection;205;0;204;0
WireConnection;205;1;194;1
WireConnection;75;0;73;0
WireConnection;75;1;59;0
WireConnection;172;0;148;0
WireConnection;172;1;22;0
WireConnection;182;0;148;0
WireConnection;182;1;27;0
WireConnection;184;0;150;0
WireConnection;184;1;27;0
WireConnection;162;0;159;0
WireConnection;162;1;172;0
WireConnection;79;0;78;0
WireConnection;183;0;149;0
WireConnection;183;1;27;0
WireConnection;207;0;205;0
WireConnection;207;1;201;0
WireConnection;76;0;75;0
WireConnection;76;1;72;4
WireConnection;179;0;178;0
WireConnection;179;1;182;0
WireConnection;160;0;159;0
WireConnection;160;1;174;0
WireConnection;181;0;178;0
WireConnection;181;1;184;0
WireConnection;173;0;149;0
WireConnection;173;1;22;0
WireConnection;176;0;162;0
WireConnection;176;1;160;0
WireConnection;176;2;154;0
WireConnection;161;0;159;0
WireConnection;161;1;173;0
WireConnection;80;0;79;0
WireConnection;80;1;167;0
WireConnection;80;2;81;0
WireConnection;186;0;179;0
WireConnection;186;1;181;0
WireConnection;186;2;154;0
WireConnection;108;0;76;0
WireConnection;180;0;178;0
WireConnection;180;1;183;0
WireConnection;209;0;207;0
WireConnection;209;1;197;0
WireConnection;187;0;186;0
WireConnection;187;1;180;0
WireConnection;187;2;155;0
WireConnection;265;2;250;0
WireConnection;235;0;234;0
WireConnection;177;0;176;0
WireConnection;177;1;161;0
WireConnection;177;2;155;0
WireConnection;210;0;209;0
WireConnection;82;0;80;0
WireConnection;82;2;124;0
WireConnection;82;3;124;0
WireConnection;218;0;108;0
WireConnection;87;0;145;0
WireConnection;87;1;82;0
WireConnection;211;0;187;0
WireConnection;211;1;210;0
WireConnection;258;0;257;0
WireConnection;258;1;265;0
WireConnection;258;2;23;0
WireConnection;237;0;236;0
WireConnection;237;1;235;0
WireConnection;199;0;177;0
WireConnection;199;1;197;0
WireConnection;254;0;265;0
WireConnection;254;1;23;0
WireConnection;256;0;250;0
WireConnection;256;1;258;0
WireConnection;216;0;20;0
WireConnection;216;1;207;0
WireConnection;215;0;13;0
WireConnection;215;1;197;0
WireConnection;223;0;222;0
WireConnection;223;1;224;0
WireConnection;223;2;197;0
WireConnection;213;0;211;0
WireConnection;213;1;28;0
WireConnection;214;0;199;0
WireConnection;214;1;21;0
WireConnection;251;0;250;0
WireConnection;251;1;254;0
WireConnection;92;0;16;0
WireConnection;92;1;91;1
WireConnection;94;0;10;0
WireConnection;94;1;91;1
WireConnection;94;2;87;0
WireConnection;188;0;189;0
WireConnection;188;1;157;0
WireConnection;238;0;237;0
WireConnection;238;1;239;0
WireConnection;221;0;14;0
WireConnection;221;1;222;0
WireConnection;261;0;256;0
WireConnection;261;1;251;0
WireConnection;225;0;223;0
WireConnection;116;0;91;1
WireConnection;240;0;237;0
WireConnection;240;1;241;0
WireConnection;240;2;238;0
WireConnection;191;0;190;0
WireConnection;191;1;188;0
WireConnection;96;0;92;0
WireConnection;96;1;94;0
WireConnection;217;0;216;0
WireConnection;217;1;213;0
WireConnection;217;2;214;0
WireConnection;217;3;215;0
WireConnection;244;0;11;0
WireConnection;244;1;240;0
WireConnection;220;0;217;0
WireConnection;220;1;221;0
WireConnection;220;2;225;0
WireConnection;98;0;96;0
WireConnection;118;0;219;0
WireConnection;118;1;116;0
WireConnection;262;0;24;0
WireConnection;262;1;261;0
WireConnection;192;0;191;0
WireConnection;89;0;90;0
WireConnection;243;0;220;0
WireConnection;243;1;244;0
WireConnection;243;2;242;0
WireConnection;243;3;247;1
WireConnection;97;0;98;0
WireConnection;97;1;89;0
WireConnection;263;0;262;0
WireConnection;263;1;197;0
WireConnection;230;0;192;0
WireConnection;230;1;29;0
WireConnection;101;0;89;0
WireConnection;101;1;118;0
WireConnection;101;2;17;0
WireConnection;231;0;197;0
WireConnection;231;1;230;0
WireConnection;231;2;229;0
WireConnection;109;0;97;0
WireConnection;109;1;101;0
WireConnection;264;0;243;0
WireConnection;264;1;263;0
WireConnection;0;0;264;0
WireConnection;0;2;231;0
WireConnection;0;4;248;0
WireConnection;0;11;109;0
ASEEND*/
//CHKSM=B51B1EDDF7DB287E1F5B1925278D6221F31F61B3